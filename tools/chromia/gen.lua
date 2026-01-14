-- bootstrap module path (relative to this script)
local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

local ppm = require("ppm")
local sample = require("sample")

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

-- ===== preview: colored dots like fastfetch =====
local DOT = "" -- Nerd Font glyph; fallback: "●"

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16),
         tonumber(hex:sub(3, 4), 16),
         tonumber(hex:sub(5, 6), 16)
end

local function ansi_fg_rgb(r, g, b)
  -- 24-bit truecolor foreground
  return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

local function ansi_reset()
  return "\27[0m"
end

-- print dots line
for _, hex in ipairs(colors) do
  local r, g, b = hex_to_rgb(hex)
  io.write(ansi_fg_rgb(r, g, b), DOT, " ")
end
io.write(ansi_reset(), "\n")

-- optional: also print hex values (comment out if you don't want)
for _, hex in ipairs(colors) do
  print(hex)
end

-------------------------------------------- ===== write waybar css variables ===== --------------------------------------------
local function clamp(x) return math.max(0, math.min(255, x)) end

local function rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

local function hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16),
         tonumber(hex:sub(3, 4), 16),
         tonumber(hex:sub(5, 6), 16)
end

local function luma(hex)
  local r, g, b = hex_to_rgb(hex)
  -- perceptual-ish luma
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

local function adjust(hex, delta) -- delta: -255..255
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hex(clamp(r + delta), clamp(g + delta), clamp(b + delta))
end

-- pick bg/fg by luma
table.sort(colors, function(a, b) return luma(a) < luma(b) end)
local bg = colors[1]
local fg = colors[#colors]

-- accents: take mid colors (skip bg/fg ends)
local accents = {}
for i = 2, math.min(#colors - 1, 8) do
  table.insert(accents, colors[i])
end
-- ensure we have at least 7 accents
while #accents < 7 do
  table.insert(accents, fg)
end

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
