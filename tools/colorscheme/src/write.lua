-- write.lua 
local h = require("helper")
local s = require("strategy")
require("colors")

---@param p tdf.Colors
local function write_hypr(p)
	local path = os.getenv("HOME") .. "/.config/hypr/hyprland/colors.g.lua"
	local f = assert(io.open(path, "w"))
	local header = [[
-- Generated from wallpaper
-- Do not edit manually!

]]
	local content = header .. [[
return {
  active_border_color = "rgba(%sff)",
  inactive_border_color = "%s",
}
]]
	f:write(content:format(p.accent:sub(2), p.bg_border))
	f:close()
end

---@param p tdf.Colors
local function write_waybar(p)
	local path = os.getenv("HOME") .. "/.config/waybar/colors.g.css"
	local f = assert(io.open(path, "w"))
	local content = [[
/* Generated from wallpaper */
/* Do not edit manually! */

/* background */
@define-color bg %s;
@define-color bg-elevated %s;
@define-color bg-hover %s;
@define-color bg-active %s;
@define-color bg-border %s;
@define-color bg-shadow %s;

/* text */
@define-color fg %s;
@define-color fg-hover %s;
@define-color fg-muted %s;
@define-color fg-subtle %s;
@define-color fg-shadow %s;

/* accents */
@define-color accent %s;
@define-color accent-soft %s;
@define-color accent-strong %s;
@define-color accent-fg %s;

]]
	f:write(
		content:format(
			p.bg,
			p.bg_elevated,
			p.bg_hover,
			p.bg_active,
			p.bg_border,
			p.bg_shadow,
			p.fg,
			p.fg_hover,
			p.fg_muted,
			p.fg_subtle,
			p.fg_shadow,
			p.accent,
			p.accent_soft,
			p.accent_strong,
			p.accent_fg
		)
	)
	f:write(string.format("@define-color a %s;\n", p.accent))
	for i = 1, 6 do
		f:write(string.format("@define-color a%d %s;\n", i, p.accents[i]))
	end
	f:close()
end

---@param p tdf.Colors
local function write_kitty(p)
  local path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"

  local active_template = string.format(
    "{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
    "_" .. p.accent_fg:sub(2),
    "_" .. p.bg:sub(2),
    "_" .. p.accent:sub(2),
    "_" .. p.accent_fg:sub(2),
    "_" .. p.accent_fg:sub(2),
    "_" .. p.bg:sub(2)
  )
  local inactive_template = string.format(
    "{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
    "_" .. p.fg_muted:sub(2),
    "_" .. p.bg:sub(2),
    "_" .. p.bg_elevated:sub(2),
    "_" .. p.fg_muted:sub(2),
    "_" .. p.fg_muted:sub(2),
    "_" .. p.bg:sub(2)
  )

  local color16 = {}
  for i = 0, 7 do
    table.insert(color16, string.format("color%d %s", i, p.ansi_normal[i + 1]))
    table.insert(color16, string.format("color%d %s", i + 8, p.ansi_bright[i + 1]))
  end

  local template = [[
# Generated from wallpaper

foreground %s
background %s
selection_foreground %s
selection_background %s
cursor %s
cursor_text_color %s
url_color %s
active_border_color %s
inactive_border_color %s
bell_border_color %s
wayland_titlebar_color system
active_tab_foreground %s
active_tab_background %s
inactive_tab_foreground %s
inactive_tab_background %s
tab_bar_background %s
mark1_foreground %s
mark1_background %s
mark2_foreground %s
mark2_background %s
mark3_foreground %s
mark3_background %s
%s

active_tab_title_template %q
tab_title_template %q
]]

  local content = template:format(
    p.fg,
    p.bg,
    p.accent_fg,
    p.accent,
    p.accent_strong,
    p.accent_fg,
    p.accent_strong,
    p.accent_strong,
    p.bg_border,
    p.accents[2],
    p.accent_fg,
    p.accent,
    p.fg_muted,
    p.bg_elevated,
    p.bg,
    p.accent_fg,
    p.accent,
    p.accent_fg,
    p.accents[2],
    p.accent_fg,
    p.accents[3],
    table.concat(color16, "\n"),
    active_template,
    inactive_template
  )

  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
end

---@param p tdf.Colors
local function write_rofi(p)
	local path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
	local f = assert(io.open(path, "w"))
	f:write(string.format(
		[[
* {
    bg: %s;
    fg: %s;
    bg-elevated: %s;
    bg-lighter: %s;
    bg-active: %s;
    border: %s;
    fg-muted: %s;
    fg-subtle: %s;
    fg-hover: %s;
    accent: %s;
    accent-fg: %s;
]],
		p.bg,
		p.fg,
    p.bg_elevated,
		p.bg_hover,
		p.bg_active,
		p.bg_border,
    p.fg_muted,
    p.fg_subtle,
    p.fg_hover,
		p.accent,
		p.accent_fg
	))
	for i = 1, 6 do
		f:write(string.format("    a%d: %s;\n", i, p.accents[i]))
	end
	f:write("}\n")
	f:close()
end

---@param p tdf.Colors
local function write_fcitx5(p)
  local path = os.getenv("HOME") .. "/.local/share/fcitx5/themes/auto-gen/theme.conf"
  os.execute("mkdir -p " .. path:match("(.*/)"))
  local f = assert(io.open(path, "w"))

  local asset_theme = p.dark_mode and "default-dark" or "default"
  local asset_root = "/usr/share/fcitx5/themes/" .. asset_theme

  local template = [[
[Metadata]
Name=Auto Gen
Version=1
Author=ToaaM
Description=Auto generated theme
ScaleWithDPI=True

[InputPanel]
NormalColor=%s
HighlightCandidateColor=%s
HighlightColor=%s
HighlightBackgroundColor=%s
PageButtonAlignment=Last Candidate

[InputPanel/TextMargin]
Left=5
Right=5
Top=5
Bottom=5

[InputPanel/ContentMargin]
Left=2
Right=2
Top=2
Bottom=2

[InputPanel/Background]
Color=%s
BorderColor=%s
BorderWidth=2

[InputPanel/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[InputPanel/Highlight]
Color=%s

[InputPanel/Highlight/Margin]
Left=5
Right=5
Top=5
Bottom=5

[InputPanel/PrevPage]
Image=%s/prev.png

[InputPanel/PrevPage/ClickMargin]
Left=5
Right=5
Top=4
Bottom=4

[InputPanel/NextPage]
Image=%s/next.png

[InputPanel/NextPage/ClickMargin]
Left=5
Right=5
Top=4
Bottom=4

[Menu]
NormalColor=%s
HighlightCandidateColor=%s

[Menu/Background]
Color=%s
BorderColor=%s
BorderWidth=2

[Menu/Background/Margin]
Left=2
Right=2
Top=2
Bottom=2

[Menu/ContentMargin]
Left=2
Right=2
Top=2
Bottom=2

[Menu/CheckBox]
Image=%s/radio.png

[Menu/SubMenu]
Image=%s/arrow.png

[Menu/Highlight]
Color=%s

[Menu/Highlight/Margin]
Left=5
Right=5
Top=5
Bottom=5

[Menu/Separator]
Color=%s

[Menu/TextMargin]
Left=5
Right=5
Top=5
Bottom=5

[AccentColorField]
0=Input Panel Border
1=Input Panel Highlight Candidate Background
2=Input Panel Highlight
3=Menu Border
4=Menu Separator
5=Menu Selected Item Background
]]

  local content = template:format(
    p.fg,                           -- NormalColor
    p.accent_fg,                    -- HighlightCandidateColor
    p.accent_fg,                    -- HighlightColor
    p.accent,                       -- HighlightBackgroundColor
    p.bg,                           -- [InputPanel/Background] Color
    p.bg_border,                    -- BorderColor
    p.bg_active,                    -- [InputPanel/Highlight] Color
    asset_root,                     -- [InputPanel/PrevPage] Image
    asset_root,                     -- [InputPanel/NextPage] Image
    p.fg,                           -- [Menu] NormalColor
    p.accent_fg,                    -- [Menu] HighlightCandidateColor
    p.bg,                           -- [Menu/Background] Color
    p.bg_border,                    -- [Menu/Background] BorderColor
    asset_root,                     -- [Menu/CheckBox] Image
    asset_root,                     -- [Menu/SubMenu] Image
    p.bg_active,                    -- [Menu/Highlight] Color
    p.bg_border                     -- [Menu/Separator] Color
  )

  f:write(content)
  f:close()
end

---@param p tdf.Colors
local function write_nvim(p)
	local syntax_keys = {
		"keyword",
		"keyword_flow",
		"keyword_return",
		"string",
		"number",
		"type",
		"func",
		"func_call",
		"variable",
		"constant",
		"macro",
		"builtin",
		"property",
		"parameter",
		"operator",
		"punctuation",
		"namespace",
	}

	local path = os.getenv("HOME") .. "/.config/nvim/lua/colors/g.lua"
	os.execute("mkdir -p " .. path:match("(.*/)"))

	local f = assert(io.open(path, "w"))

	local template = [[
-- Generated from wallpaper
-- Do not edit manually!

return {
  dark_mode = %s,
  bg = %q,
  fg = %q,
  bg_elevated = %q,
  bg_hover = %q,
  bg_active = %q,
  bg_border = %q,
  bg_shadow = %q,
  fg_muted = %q,
  fg_subtle = %q,
  fg_hover = %q,
  fg_shadow = %q,
  accent = %q,
  accent_soft = %q,
  accent_strong = %q,
  accent_fg = %q,
  accents = {%s},
  syntax = {%s},
  ansi_normal = {%s},
  ansi_bright = {%s},
}
]]

	-- accents
	local accent_lines = {}
	for _, a in ipairs(p.accents) do
		accent_lines[#accent_lines + 1] = string.format("%q,", a)
	end

	-- syntax
	local syntax_lines = {}
	for _, key in ipairs(syntax_keys) do
		syntax_lines[#syntax_lines + 1] = string.format("%s = %q,", key, p.syntax[key])
	end

	-- ansi_normal
	local ansi_normal_items = {}
	for i = 1, 8 do
		ansi_normal_items[#ansi_normal_items + 1] = string.format("%q", p.ansi_normal[i])
	end

	-- ansi_bright
	local ansi_bright_items = {}
	for i = 1, 8 do
		ansi_bright_items[#ansi_bright_items + 1] = string.format("%q", p.ansi_bright[i])
	end

	local content = template:format(
		p.dark_mode and "true" or "false",
		p.bg,
		p.fg,
		p.bg_elevated,
		p.bg_hover,
		p.bg_active,
		p.bg_border,
		p.bg_shadow,
		p.fg_muted,
		p.fg_subtle,
		p.fg_hover,
		p.fg_shadow,
		p.accent,
		p.accent_soft,
		p.accent_strong,
		p.accent_fg,
		table.concat(accent_lines, "\n"),
		table.concat(syntax_lines, "\n"),
		table.concat(ansi_normal_items, ", "),
		table.concat(ansi_bright_items, ", ")
	)

	f:write(content)
	f:close()

  os.execute("stylua " .. path .. " 2>/dev/null")
end

---@param p tdf.Colors
local function write_cava(p)
	local path = os.getenv("HOME") .. "/.config/cava/themes/colors.g.theme"
	os.execute("mkdir -p " .. path:match("(.*/)"))

	local template = [[
[color]
background = default
foreground = '%s'
gradient = 1
%s
]]

	local b = p.dark_mode and s.lift_contrast(h.mix(p.accent, p.fg, 0.60), p.bg, 4.4, 0.14)
		or s.lift_contrast(h.mix(p.accent, "#ffffff", 0.34), p.bg, 3.6, 0.14)
	local m = p.dark_mode and s.lift_contrast(h.mix(p.accent, p.accents[2], 0.48), p.bg, 3.2, 0.14)
		or s.lift_contrast(h.mix(p.accent, p.accents[2], 0.55), p.bg, 3.0, 0.14)
	local t = p.dark_mode and s.lift_contrast(h.mix(p.accents[2], p.bg, 0.78), p.bg, 1.35, 0.14)
		or s.lift_contrast(h.mix(p.accents[2], "#000000", 0.58), p.bg, 2.1, 0.14)

	local gradient_lines = {}
	for i = 1, 8 do
		local ratio = (i - 1) / 7
		local shade = ratio <= 0.5 and h.mix(b, m, ratio / 0.5) or h.mix(m, t, (ratio - 0.5) / 0.5)
		local color = s.lift_contrast(shade, p.bg, p.dark_mode and 1.7 or 2.1, 0.12)
		gradient_lines[#gradient_lines + 1] = string.format("gradient_color_%d = '%s'", i, color)
	end

	local content = template:format(p.accent, table.concat(gradient_lines, "\n"))

	local f = assert(io.open(path, "w"))
	f:write(content)
	f:close()
end

---@param p tdf.Colors
local function write_mako(p)
  local path = os.getenv("HOME") .. "/.config/mako/g.colors"
  os.execute("mkdir -p " .. path:match("(.*/)"))
  local template = [[
# Generated from wallpaper

background-color=%s
text-color=%s
border-color=%s
]]
  local content = template:format(
    p.bg,
    p.fg,
    p.bg_border
  )
  local f = assert(io.open(path, "w"))
  f:write(content)
  f:close()
end

local M = {}

---@param p tdf.Colors
function M.preview(p)
	local DOT = " "
	for _, hex in ipairs(p.preview) do
		local r, g, b = h.to_rgb(hex)
		io.write(string.format("\27[38;2;%d;%d;%dm%s", r, g, b, DOT))
	end
	io.write("\27[0m\n")
	for _, hex in ipairs(p.preview) do
		print(hex)
	end
end

---@param p tdf.Colors
function M.invoke(p)
	write_hypr(p)
	write_waybar(p)
	write_kitty(p)
	write_cava(p)
	write_rofi(p)
	write_fcitx5(p)
	write_nvim(p)
	write_mako(p)

	-- reload
	os.execute("hyprctl reload config-only")
	os.execute("makoctl reload >/dev/null 2>&1")
	os.execute("fcitx5 -rd >/dev/null 2>&1")
	os.execute("pkill -SIGUSR1 kitty")
end

return M
