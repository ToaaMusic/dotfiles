local helper = require("helper")

local M = {}

-- internal

local lift_contrast = helper.lift_contrast
local mix = helper.mix
local upsert_generated_block = helper.upsert_generated_block

local function write_waybar(palette)
  local path = os.getenv("HOME") .. "/.config/waybar/colors.g.css"
  local f = assert(io.open(path, "w"))

  f:write(string.format("@define-color bg %s;\n", palette.bg))
  f:write(string.format("@define-color bg-elevated %s;\n", palette.bg_elevated))
  f:write(string.format("@define-color bg-hover %s;\n", palette.bg_hover))
  f:write(string.format("@define-color bg-active %s;\n", palette.bg_active))
  f:write(string.format("@define-color bg-border %s;\n", palette.bg_border))
  f:write(string.format("@define-color bg-shadow %s;\n\n", palette.bg_shadow))

  f:write("/* text */\n\n")
  f:write(string.format("@define-color fg %s;\n", palette.fg))
  f:write(string.format("@define-color fg-hover %s;\n", palette.fg_hover))
  f:write(string.format("@define-color fg-muted %s;\n", palette.fg_muted))
  f:write(string.format("@define-color fg-subtle %s;\n", palette.fg_subtle))
  f:write(string.format("@define-color fg-shadow %s;\n\n", palette.fg_shadow))

  f:write("/* accents */\n\n")
  f:write(string.format("@define-color accent %s;\n", palette.accent))
  f:write(string.format("@define-color accent-soft %s;\n", palette.accent_soft))
  f:write(string.format("@define-color accent-strong %s;\n", palette.accent_strong))
  f:write(string.format("@define-color accent-fg %s;\n", palette.accent_fg))
  f:write(string.format("@define-color a %s;\n", palette.accent))
  for i = 1, 6 do
    f:write(string.format("@define-color a%d %s;\n", i, palette.accents[i]))
  end

  f:close()
end

local function write_kitty(palette)
  local path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"
  local f = assert(io.open(path, "w"))

  f:write("# Generated Kitty Theme\n")
  f:write(string.format("foreground %s\n", palette.fg))
  f:write(string.format("background %s\n", palette.bg))
  f:write(string.format("selection_foreground %s\n", palette.accent_fg))
  f:write(string.format("selection_background %s\n", palette.accent))
  f:write(string.format("cursor %s\n", palette.accent_strong))
  f:write(string.format("cursor_text_color %s\n", palette.accent_fg))
  f:write(string.format("url_color %s\n", palette.accent_strong))
  f:write(string.format("active_border_color %s\n", palette.accent_strong))
  f:write(string.format("inactive_border_color %s\n", palette.bg_border))
  f:write(string.format("bell_border_color %s\n", palette.accents[2]))
  f:write("wayland_titlebar_color system\n")
  f:write(string.format("active_tab_foreground %s\n", palette.accent_fg))
  f:write(string.format("active_tab_background %s\n", palette.accent))
  f:write(string.format("inactive_tab_foreground %s\n", palette.fg_muted))
  f:write(string.format("inactive_tab_background %s\n", palette.bg_elevated))
  f:write(string.format("tab_bar_background %s\n", palette.bg_hover))
  f:write(string.format("mark1_foreground %s\n", palette.accent_fg))
  f:write(string.format("mark1_background %s\n", palette.accent))
  f:write(string.format("mark2_foreground %s\n", palette.accent_fg))
  f:write(string.format("mark2_background %s\n", palette.accents[2]))
  f:write(string.format("mark3_foreground %s\n", palette.accent_fg))
  f:write(string.format("mark3_background %s\n\n", palette.accents[3]))

  for i = 0, 7 do
    f:write(string.format("color%d %s\n", i, palette.kitty_normal[i + 1]))
    f:write(string.format("color%d %s\n", i + 8, palette.kitty_bright[i + 1]))
  end

  f:close()
end

local function write_cava(palette)
  os.execute(string.format("mkdir -p %q", os.getenv("HOME") .. "/.config/cava/themes"))
  local path = os.getenv("HOME") .. "/.config/cava/themes/colors.g.theme"
  local f = assert(io.open(path, "w"))

  local gradient = {}
  local bottom = palette.dark_mode
    and lift_contrast(mix(palette.accent, palette.fg, 0.60), palette.bg, 4.4, 0.14)
    or lift_contrast(mix(palette.accent, "#ffffff", 0.34), palette.bg, 3.6, 0.14)
  local mid = palette.dark_mode
    and lift_contrast(mix(palette.accent, palette.accents[2], 0.48), palette.bg, 3.2, 0.14)
    or lift_contrast(mix(palette.accent, palette.accents[2], 0.55), palette.bg, 3.0, 0.14)
  local top = palette.dark_mode
    and lift_contrast(mix(palette.accents[2], palette.bg, 0.78), palette.bg, 1.35, 0.14)
    or lift_contrast(mix(palette.accents[2], "#000000", 0.58), palette.bg, 2.1, 0.14)

  for i = 1, 8 do
    local t = (i - 1) / 7
    local shade
    if t <= 0.5 then
      shade = mix(bottom, mid, t / 0.5)
    else
      shade = mix(mid, top, (t - 0.5) / 0.5)
    end
    gradient[i] = lift_contrast(shade, palette.bg, palette.dark_mode and 1.7 or 2.1, 0.12)
  end

  f:write("[color]\n")
  f:write("background = default\n")
  f:write(string.format("foreground = '%s'\n", palette.accent))
  f:write("gradient = 1\n")
  for i = 1, 8 do
    f:write(string.format("gradient_color_%d = '%s'\n", i, gradient[i]))
  end
  f:close()
end

local function write_rofi(palette)
  local path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
  local f = assert(io.open(path, "w"))

  f:write("* {\n")
  f:write(string.format("    bg: %s;\n", palette.bg))
  f:write(string.format("    fg: %s;\n", palette.fg))
  f:write(string.format("    bg-lighter: %s;\n", palette.bg_hover))
  f:write(string.format("    bg-active: %s;\n", palette.bg_active))
  f:write(string.format("    border: %s;\n", palette.bg_border))
  f:write(string.format("    accent: %s;\n", palette.accent))
  f:write(string.format("    accent-fg: %s;\n", palette.accent_fg))
  for i = 1, 6 do
    f:write(string.format("    a%d: %s;\n", i, palette.accents[i]))
  end
  f:write("}\n")

  f:close()
end

local function write_dunst(palette)
  local path = os.getenv("HOME") .. "/.config/dunst/dunstrc"
  local content = string.format([[
[fullscreen]
  background = "%s"
  foreground = "%s"
]], palette.bg, palette.fg)

  upsert_generated_block(path, content, "#")
  os.execute("dunstctl reload")
end

local function write_nvim(palette)
  local path = os.getenv("HOME") .. "/.config/nvim/lua/colors/g.lua"
  local dir = path:match("(.*/)")
  os.execute("mkdir -p " .. dir)

  local f = assert(io.open(path, "w"))

  f:write("-- Generated by wallpaper gen.lua\n")
  f:write("-- Do not edit manually!\n\n")
  f:write("return {\n")
  f:write(string.format("  dark_mode = %s,\n", palette.dark_mode and "true" or "false"))
  f:write(string.format("  bg = %q,\n", palette.bg))
  f:write(string.format("  fg = %q,\n", palette.fg))
  f:write(string.format("  bg_elevated = %q,\n", palette.bg_elevated))
  f:write(string.format("  bg_hover = %q,\n", palette.bg_hover))
  f:write(string.format("  bg_active = %q,\n", palette.bg_active))
  f:write(string.format("  bg_border = %q,\n", palette.bg_border))
  f:write(string.format("  bg_shadow = %q,\n", palette.bg_shadow))
  f:write(string.format("  fg_muted = %q,\n", palette.fg_muted))
  f:write(string.format("  fg_subtle = %q,\n", palette.fg_subtle))
  f:write(string.format("  fg_hover = %q,\n", palette.fg_hover))
  f:write(string.format("  fg_shadow = %q,\n", palette.fg_shadow))
  f:write(string.format("  accent = %q,\n", palette.accent))
  f:write(string.format("  accent_soft = %q,\n", palette.accent_soft))
  f:write(string.format("  accent_strong = %q,\n", palette.accent_strong))
  f:write(string.format("  accent_fg = %q,\n", palette.accent_fg))
  f:write("  accents = {\n")
  for i = 1, 6 do
    f:write(string.format("    %q,\n", palette.accents[i]))
  end
  f:write("  },\n")
  f:write("  kitty_normal = {")
  for i = 1, 8 do
    f:write(string.format("%q%s", palette.kitty_normal[i], i < 8 and ", " or ""))
  end
  f:write("},\n")
  f:write("  kitty_bright = {")
  for i = 1, 8 do
    f:write(string.format("%q%s", palette.kitty_bright[i], i < 8 and ", " or ""))
  end
  f:write("},\n")
  f:write("}\n")

  f:close()
end

-- public

--- Write the generated palette to all target configs.
function M.apply(palette)
  write_waybar(palette)
  write_kitty(palette)
  write_cava(palette)
  write_rofi(palette)
  write_dunst(palette)
  write_nvim(palette)
end

return M
