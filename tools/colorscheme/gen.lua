-- bootstrap module path (relative to this script)
local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

local ppm = require("ppm")
local sample = require("sample")
local helper = require("helper")

local img, err = ppm.from_stdin()
if not img then error(err) end

ppm.seed_rng(img)

-- 只采样屏幕中间区域，避免边缘/栏/角落干扰（可删）
local region = sample.center_region(img, 0.12)

local colors = sample.top_colors(img, {
  samples = 20000,
  topn = 12,
  qbits = 5,
  region = region,
  min_luma = 15,   -- 过滤太黑（可调/可删）
  max_luma = 245,  -- 过滤太白（可调/可删）
})

---===== preview =====
local DOT = "" -- Nerd Font glyph; fallback: "●"

local function ansi_reset()
  return "\27[0m"
end

local function ansi_fg_rgb(r, g, b)
  -- 24-bit truecolor foreground
  return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end


-- print dots line
local function preview_colors()
  for _, hex in ipairs(colors) do
    local r, g, b = hex_to_rgb(hex)
    io.write(ansi_fg_rgb(r, g, b), DOT, " ")
  end
  io.write(ansi_reset(), "\n")

  -- optional: also print hex values (comment out if you don't want)
  for _, hex in ipairs(colors) do
    print(hex)
  end
end
-------------------------------------------- ===== write waybar css variables ===== --------------------------------------------
--#region helpers

--- 避免RGB数值溢出
local function clamp(x) return math.max(0, math.min(255, x)) end

--- 计算感知亮度
local function luma(hex)
  local r, g, b = hex_to_rgb(hex)
  -- perceptual-ish luma
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- RGB整体加减
--- delta: -255..255
local function adjust(hex, delta) 
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hex(clamp(r + delta), clamp(g + delta), clamp(b + delta))
end

--- 根据得到的排序判断白天还是黑夜模式合适
--- @return boolean
local function is_day_mode()
  local mid_index = math.floor(#colors / 2)
  local mid_luma = luma(colors[mid_index])
  return mid_luma < 128
end

--#endregion

-- 算luma排序
table.sort(colors, function(a, b) return luma(a) < luma(b) end)

local bg, fg
-- 新：看整体亮度，如果暗色多就用亮的做bg
if is_day_mode() then
  -- local rev_colors = {}
  -- for i = #colors, 1, -1 do
  --   table.insert(rev_colors, colors[i])
  -- end
  -- colors = rev_colors
  bg = colors[#colors]
  fg = colors[1]
else
  bg = colors[1]
  fg = colors[#colors]
end

-- accents: take mid colors (skip bg/fg ends)
local accents = {}
for i = 2, math.min(#colors - 1, 8) do
  table.insert(accents, colors[i])
end
-- ensure we have at least 7 accents
while #accents < 7 do
  table.insert(accents, fg)
end

-------------------------------------------- ===== write waybar color scheme ===== --------------------------------------------

local out_path = os.getenv("HOME") .. "/.config/waybar/colors.g.css"
local f = assert(io.open(out_path, "w"))

f:write(string.format('@define-color bg %s;\n', bg))
f:write(string.format('@define-color bg-hover %s;\n', adjust(bg, 10)))
f:write(string.format('@define-color bg-border %s;\n', adjust(bg, 35)))
f:write('@define-color bg-shadow #101010;\n\n')

f:write('/* text */\n\n')
f:write(string.format('@define-color fg %s;\n', fg))
f:write(string.format('@define-color fg-hover %s;\n', adjust(fg, -15)))
f:write('@define-color fg-shadow rgba(0, 0, 0, 0.377);\n')
f:write(string.format('@define-color fg-muted %s;\n\n', adjust(fg, -60)))

f:write('/* accents */\n\n')
f:write(string.format('@define-color a %s;\n', accents[1]))
for i = 1, 6 do
  f:write(string.format('@define-color a%d %s;\n', i, accents[i + 1]))
end

f:close()

-- print path for debugging
print("Wrote:", out_path)
preview_colors()

-------------------------------------------- ===== write kitty color scheme ===== --------------------------------------------
local kitty_path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"
local kf = assert(io.open(kitty_path, "w"))
kf:write(string.format("background %s\n", bg))
kf:write(string.format("foreground %s\n\n", fg))

kf:close()

-------------------------------------------- ===== write rofi color scheme ===== ---------------------------------------------
local rofi_path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
local rf = assert(io.open(rofi_path, "w"))
rf:write("* {\n")
rf:write(string.format("    bg: %s;\n", bg))
rf:write(string.format("    fg: %s;\n", fg))

rf:write(string.format("    bg-lighter: %s;\n", adjust(bg, 15))) -- for rofi entry bg

for i = 1, 6 do
  rf:write(string.format("    a%d: %s;\n", i, accents[i + 1]))
end
rf:write("}\n")
rf:close()

-------------------------------------------- ===== write dunst color scheme ===== ---------------------------------------------
local dunst_path = os.getenv("HOME") .. "/.config/dunst/dunstrc"
local content = string.format([[
[fullscreen]
  background = "%s"
  foreground = "%s"
]], bg, fg)
upsert_generated_block(dunst_path,content,"#")
-- os.execute("pkill dunst")
-- os.execute("dunst &")
os.execute("dunstctl reload")

-------------------------------------------- ===== send notification ===== --------------------------------------------

send_notify("Color Scheme updated", "waybar/colors.g.css\nkitty/colors.g.conf\nrofi/colors.g.rasi\ndunst/dunstrc")