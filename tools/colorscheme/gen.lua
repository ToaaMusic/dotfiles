-- bootstrap module path (relative to this script)
local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

require("helper")
local sample = require("sample")
local ppm = sample.ppm

local img, err = ppm.from_stdin()
if not img then
  error(err)
end

ppm.seed_rng(img)

local region = sample.center_region(img, 0.12)
local dominant_colors = sample.top_colors(img, {
  samples = 24000,
  topn = 16,
  qbits = 5,
  region = region,
  min_luma = 8,
  max_luma = 248,
})

if #dominant_colors < 4 then
  error("not enough colors sampled from image")
end

local DOT = ""

local function ansi_reset()
  return "\27[0m"
end

local function ansi_fg_rgb(r, g, b)
  return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

local function preview_colors(colors)
  for _, hex in ipairs(colors) do
    local r, g, b = hex_to_rgb(hex)
    io.write(ansi_fg_rgb(r, g, b), DOT, " ")
  end
  io.write(ansi_reset(), "\n")

  for _, hex in ipairs(colors) do
    print(hex)
  end
end

local function copy_table(t)
  local out = {}
  for i, v in ipairs(t) do
    out[i] = v
  end
  return out
end

local function unique_colors(colors)
  local out, seen = {}, {}
  for _, hex in ipairs(colors) do
    local key = hex:lower()
    if not seen[key] then
      seen[key] = true
      out[#out + 1] = hex
    end
  end
  return out
end

local function push_if_distinct(out, hex, min_distance)
  min_distance = min_distance or 20
  for _, existing in ipairs(out) do
    if color_distance(existing, hex) < min_distance then
      return false
    end
  end
  out[#out + 1] = hex
  return true
end

local function push_if_varied(out, hex, min_distance, min_hue_distance)
  min_distance = min_distance or 20
  min_hue_distance = min_hue_distance or 22
  local has_hue = hue_degrees(hex) ~= nil
  for _, existing in ipairs(out) do
    if color_distance(existing, hex) < min_distance then
      return false
    end
    if has_hue and hue_degrees(existing) ~= nil and hue_distance(existing, hex) < min_hue_distance then
      return false
    end
  end
  out[#out + 1] = hex
  return true
end

local sorted_by_luma = copy_table(unique_colors(dominant_colors))
table.sort(sorted_by_luma, function(a, b)
  return luma(a) < luma(b)
end)

local median_color = sorted_by_luma[math.ceil(#sorted_by_luma / 2)]
local wallpaper_is_dark = luma(median_color) < 140
local contrast_theme = true
local dark_mode = contrast_theme and not wallpaper_is_dark or wallpaper_is_dark

local bg = dark_mode and sorted_by_luma[1] or sorted_by_luma[#sorted_by_luma]
local fg_seed = dark_mode and sorted_by_luma[#sorted_by_luma] or sorted_by_luma[1]
local fg = ensure_contrast(fg_seed, bg, 7)

local bg_elevated = mix(bg, fg, dark_mode and 0.10 or 0.08)
local bg_hover = mix(bg, fg, dark_mode and 0.15 or 0.12)
local bg_active = mix(bg, fg, dark_mode and 0.22 or 0.18)
local bg_border = mix(bg, fg, dark_mode and 0.28 or 0.24)
local fg_muted = ensure_contrast(mix(fg, bg, 0.35), bg, 4.5)
local fg_subtle = ensure_contrast(mix(fg, bg, 0.48), bg, 3.2)
local fg_hover = ensure_contrast(mix(fg, bg, 0.14), bg, 6)
local bg_shadow = dark_mode and "#101010" or "#bfb7af"
local fg_shadow = dark_mode and "rgba(0, 0, 0, 0.377)" or bg

local accent_candidates = {}
for _, hex in ipairs(dominant_colors) do
  if color_distance(hex, bg) >= 28 and color_distance(hex, fg) >= 24 then
    accent_candidates[#accent_candidates + 1] = hex
  end
end

table.sort(accent_candidates, function(a, b)
  local score_a = chroma(a) * 1.6 + color_distance(a, bg) * 0.35 + math.min(contrast_ratio(a, bg), 6) * 14
  local score_b = chroma(b) * 1.6 + color_distance(b, bg) * 0.35 + math.min(contrast_ratio(b, bg), 6) * 14
  return score_a > score_b
end)

local accents = {}
for _, hex in ipairs(accent_candidates) do
  if push_if_varied(accents, hex, 36, 28) and #accents >= 6 then
    break
  end
end

local accent_seed = accents[1] or sorted_by_luma[math.floor(#sorted_by_luma / 2)] or fg
local accent = lift_contrast(accent_seed, bg, 2.6, 0.16)
local accent_soft = lift_contrast(mix(accent, bg, 0.25), bg, 2.0, 0.16)
local accent_strong = lift_contrast(mix(accent, fg, 0.25), bg, 3.0, 0.16)
local accent_fg = ensure_contrast(best_text_on(accent), accent, 4.5)

local fallback_accents = {
  accent,
  accent_strong,
  accent_soft,
  lift_contrast(mix(accent, fg, 0.45), bg, 2.4, 0.16),
  lift_contrast(mix(accent, bg, 0.45), bg, 1.8, 0.16),
  lift_contrast(mix(sorted_by_luma[#sorted_by_luma], bg, 0.35), bg, 3.0, 0.16),
}

for _, hex in ipairs(fallback_accents) do
  if #accents >= 6 then
    break
  end
  push_if_varied(accents, hex, 18, 12)
end

while #accents < 6 do
  accents[#accents + 1] = lift_contrast(mix(accent, fg, 0.12 * #accents), bg, 2.0, 0.16)
end

local function kitty_ansi_palette()
  local normal = {}
  local bright = {}

  local black_slot = dark_mode and mix(bg, fg, 0.26) or mix(bg, fg, 0.68)
  local white_slot = dark_mode and mix(fg, bg, 0.18) or mix(fg, bg, 0.30)

  normal[1] = lift_contrast(black_slot, bg, 1.8, 0.18)
  normal[2] = lift_contrast(accents[1], bg, 2.8, 0.16)
  normal[3] = lift_contrast(accents[2], bg, 2.8, 0.16)
  normal[4] = lift_contrast(accents[3], bg, 2.8, 0.16)
  normal[5] = lift_contrast(accents[4], bg, 2.8, 0.16)
  normal[6] = lift_contrast(accents[5], bg, 2.8, 0.16)
  normal[7] = lift_contrast(accents[6], bg, 2.8, 0.16)
  normal[8] = ensure_contrast(white_slot, bg, 4.5)

  bright[1] = lift_contrast(mix(normal[1], fg, dark_mode and 0.28 or 0.18), bg, 2.4, 0.16)
  for i = 2, 7 do
    bright[i] = lift_contrast(mix(normal[i], fg, dark_mode and 0.22 or 0.14), bg, 3.2, 0.16)
  end
  bright[8] = ensure_contrast(fg, bg, 7)

  return normal, bright
end

local kitty_normal, kitty_bright = kitty_ansi_palette()

local preview = { bg, fg, accent }
for _, hex in ipairs(accents) do
  push_if_distinct(preview, hex, 8)
end

local bar_path = os.getenv("HOME") .. "/.config/waybar/colors.g.css"
local f = assert(io.open(bar_path, "w"))

f:write(string.format("@define-color bg %s;\n", bg))
f:write(string.format("@define-color bg-elevated %s;\n", bg_elevated))
f:write(string.format("@define-color bg-hover %s;\n", bg_hover))
f:write(string.format("@define-color bg-active %s;\n", bg_active))
f:write(string.format("@define-color bg-border %s;\n", bg_border))
f:write(string.format("@define-color bg-shadow %s;\n\n", bg_shadow))

f:write("/* text */\n\n")
f:write(string.format("@define-color fg %s;\n", fg))
f:write(string.format("@define-color fg-hover %s;\n", fg_hover))
f:write(string.format("@define-color fg-muted %s;\n", fg_muted))
f:write(string.format("@define-color fg-subtle %s;\n", fg_subtle))
f:write(string.format("@define-color fg-shadow %s;\n\n", fg_shadow))

f:write("/* accents */\n\n")
f:write(string.format("@define-color accent %s;\n", accent))
f:write(string.format("@define-color accent-soft %s;\n", accent_soft))
f:write(string.format("@define-color accent-strong %s;\n", accent_strong))
f:write(string.format("@define-color accent-fg %s;\n", accent_fg))
f:write(string.format("@define-color a %s;\n", accent))
for i = 1, 6 do
  f:write(string.format("@define-color a%d %s;\n", i, accents[i]))
end

f:close()

local kitty_path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"
local kf = assert(io.open(kitty_path, "w"))

kf:write("# Generated Kitty Theme\n")
kf:write(string.format("foreground %s\n", fg))
kf:write(string.format("background %s\n", bg))
kf:write(string.format("selection_foreground %s\n", accent_fg))
kf:write(string.format("selection_background %s\n", accent))
kf:write(string.format("cursor %s\n", accent_strong))
kf:write(string.format("cursor_text_color %s\n", accent_fg))
kf:write(string.format("url_color %s\n", accent_strong))
kf:write(string.format("active_border_color %s\n", accent_strong))
kf:write(string.format("inactive_border_color %s\n", bg_border))
kf:write(string.format("bell_border_color %s\n", accents[2]))
kf:write("wayland_titlebar_color system\n")
kf:write(string.format("active_tab_foreground %s\n", accent_fg))
kf:write(string.format("active_tab_background %s\n", accent))
kf:write(string.format("inactive_tab_foreground %s\n", fg_muted))
kf:write(string.format("inactive_tab_background %s\n", bg_elevated))
kf:write(string.format("tab_bar_background %s\n", bg_hover))
kf:write(string.format("mark1_foreground %s\n", accent_fg))
kf:write(string.format("mark1_background %s\n", accent))
kf:write(string.format("mark2_foreground %s\n", accent_fg))
kf:write(string.format("mark2_background %s\n", accents[2]))
kf:write(string.format("mark3_foreground %s\n", accent_fg))
kf:write(string.format("mark3_background %s\n\n", accents[3]))

for i = 0, 7 do
  kf:write(string.format("color%d %s\n", i, kitty_normal[i + 1]))
  kf:write(string.format("color%d %s\n", i + 8, kitty_bright[i + 1]))
end

kf:close()

os.execute(string.format("mkdir -p %q", os.getenv("HOME") .. "/.config/cava/themes"))
local cava_path = os.getenv("HOME") .. "/.config/cava/themes/colors.g.theme"
local cf = assert(io.open(cava_path, "w"))

local cava_gradient = {}
local cava_bottom = dark_mode
  and lift_contrast(mix(accent, fg, 0.60), bg, 4.4, 0.14)
  or lift_contrast(mix(accent, "#ffffff", 0.34), bg, 3.6, 0.14)
local cava_mid = dark_mode
  and lift_contrast(mix(accent, accents[2], 0.48), bg, 3.2, 0.14)
  or lift_contrast(mix(accent, accents[2], 0.55), bg, 3.0, 0.14)
local cava_top = dark_mode
  and lift_contrast(mix(accents[2], bg, 0.78), bg, 1.35, 0.14)
  or lift_contrast(mix(accents[2], "#000000", 0.58), bg, 2.1, 0.14)

for i = 1, 8 do
  local t = (i - 1) / 7
  local shade
  if t <= 0.5 then
    shade = mix(cava_bottom, cava_mid, t / 0.5)
  else
    shade = mix(cava_mid, cava_top, (t - 0.5) / 0.5)
  end
  cava_gradient[i] = lift_contrast(shade, bg, dark_mode and 1.7 or 2.1, 0.12)
end

cf:write("[color]\n")
cf:write("background = default\n")
cf:write(string.format("foreground = '%s'\n", accent))
cf:write("gradient = 1\n")
for i = 1, 8 do
  cf:write(string.format("gradient_color_%d = '%s'\n", i, cava_gradient[i]))
end
cf:close()

local rofi_path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
local rf = assert(io.open(rofi_path, "w"))
rf:write("* {\n")
rf:write(string.format("    bg: %s;\n", bg))
rf:write(string.format("    fg: %s;\n", fg))
rf:write(string.format("    bg-lighter: %s;\n", bg_hover))
rf:write(string.format("    bg-active: %s;\n", bg_active))
rf:write(string.format("    border: %s;\n", bg_border))
rf:write(string.format("    accent: %s;\n", accent))
rf:write(string.format("    accent-fg: %s;\n", accent_fg))
for i = 1, 6 do
  rf:write(string.format("    a%d: %s;\n", i, accents[i]))
end
rf:write("}\n")
rf:close()

local dunst_path = os.getenv("HOME") .. "/.config/dunst/dunstrc"
local content = string.format([[
[fullscreen]
  background = "%s"
  foreground = "%s"
]], bg, fg)
upsert_generated_block(dunst_path, content, "#")
os.execute("dunstctl reload")

local nvim_path = os.getenv("HOME") .. "/.config/nvim/lua/colors/g.lua"
local dir = nvim_path:match("(.*/)")
os.execute("mkdir -p " .. dir)

local nf = assert(io.open(nvim_path, "w"))

nf:write("-- Generated by wallpaper gen.lua\n")
nf:write("-- Do not edit manually!\n\n")
nf:write("return {\n")
nf:write(string.format("  dark_mode = %s,\n", dark_mode and "true" or "false"))

-- 基础颜色
nf:write(string.format("  bg = %q,\n", bg))
nf:write(string.format("  fg = %q,\n", fg))
nf:write(string.format("  bg_elevated = %q,\n", bg_elevated))
nf:write(string.format("  bg_hover = %q,\n", bg_hover))
nf:write(string.format("  bg_active = %q,\n", bg_active))
nf:write(string.format("  bg_border = %q,\n", bg_border))
nf:write(string.format("  bg_shadow = %q,\n", bg_shadow))

nf:write(string.format("  fg_muted = %q,\n", fg_muted))
nf:write(string.format("  fg_subtle = %q,\n", fg_subtle))
nf:write(string.format("  fg_hover = %q,\n", fg_hover))
nf:write(string.format("  fg_shadow = %q,\n", fg_shadow))

-- Accent 系列（核心）
nf:write(string.format("  accent = %q,\n", accent))
nf:write(string.format("  accent_soft = %q,\n", accent_soft))
nf:write(string.format("  accent_strong = %q,\n", accent_strong))
nf:write(string.format("  accent_fg = %q,\n", accent_fg))

-- 6 个辅助 accent
nf:write("  accents = {\n")
for i = 1, 6 do
  nf:write(string.format("    %q,\n", accents[i]))
end
nf:write("  },\n")

-- kitty ANSI（备用）
nf:write("  kitty_normal = {")
for i = 1, 8 do
  nf:write(string.format("%q%s", kitty_normal[i], i < 8 and ", " or ""))
end
nf:write("},\n")
nf:write("  kitty_bright = {")
for i = 1, 8 do
  nf:write(string.format("%q%s", kitty_bright[i], i < 8 and ", " or ""))
end
nf:write("},\n")

nf:write("}\n")
nf:close()

preview_colors(preview)

send_notify(
  "Color Scheme updated",
  "waybar/colors.g.css\nkitty/colors.g.conf\ncava/themes/colors.g.theme\nrofi/colors.g.rasi\ndunst/dunstrc"
)
