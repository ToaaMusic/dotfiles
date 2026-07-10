-- write.lua
-- write tdf.ColorScheme to config files

local h = require("color_helper")
local s = require("strategy")

---@param p tdf.ColorScheme
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
	f:write(content:format(p.accent:sub(2), p.bg.border))
	f:close()
end

---@param p tdf.ColorScheme
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
@define-color a %s;

]]
	f:write(
		content:format(
			p.bg.common,
			p.bg.elevated,
			p.bg.hover,
			p.bg.active,
			p.bg.border,
			p.bg.shadow,
			p.fg.common,
			p.fg.hover,
			p.fg.muted,
			p.fg.subtle,
			p.fg.shadow,
			p.accent
		)
	)
	for i = 1, 6 do
		f:write(string.format("@define-color a%d %s;\n", i, p.accents[i]))
	end
	f:close()

	-- copy to gtk
	-- local gtk_path = os.getenv("HOME") .. "/.config/gtk-3.0/colors.g.css"
	-- os.execute("cp " .. path .. " " .. gtk_path)
end

---@param p tdf.ColorScheme
local function write_kitty(p)
	local path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"

	local active_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. p.accent:sub(2),
		"_" .. p.bg.common:sub(2),
		"_" .. p.accent:sub(2),
		"_" .. p.accent:sub(2),
		"_" .. p.accent:sub(2),
		"_" .. p.bg.common:sub(2)
	)
	local inactive_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. p.fg.muted:sub(2),
		"_" .. p.bg.common:sub(2),
		"_" .. p.bg.elevated:sub(2),
		"_" .. p.fg.muted:sub(2),
		"_" .. p.fg.muted:sub(2),
		"_" .. p.bg.common:sub(2)
	)

	local ansi16 = {}
	for i = 0, 7 do
		table.insert(ansi16, string.format("color%d %s\n", i, p.ansi_normal[i + 1]))
		table.insert(ansi16, string.format("color%d %s\n", i + 8, p.ansi_bright[i + 1]))
	end

	local template = [[
# Generated from wallpaper
# Do not edit manually!

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
		p.fg.common,
		p.bg.common,
		p.accents[1],
		p.accent,
		p.accents[4],
		p.accents[1],
		p.accents[4],
		p.accents[4],
		p.bg.border,
		p.accents[2],
		p.accents[1],
		p.accent,
		p.fg.muted,
		p.bg.elevated,
		p.bg.common,
		p.accents[1],
		p.accent,
		p.accents[1],
		p.accents[2],
		p.accents[1],
		p.accents[3],
		ansi16,
		active_template,
		inactive_template
	)

	local f = assert(io.open(path, "w"))
	f:write(content)
	f:close()
end

---@param p tdf.ColorScheme
local function write_rofi(p)
	local path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
	local f = assert(io.open(path, "w"))
	f:write(
		string.format(
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
			p.bg.common,
			p.fg.common,
			p.bg.elevated,
			p.bg.hover,
			p.bg.active,
			p.bg.border,
			p.fg.muted,
			p.fg.subtle,
			p.fg.hover,
			p.accent,
			p.accents[1]
		)
	)
	for i = 1, 6 do
		f:write(string.format("    a%d: %s;\n", i, p.accents[i]))
	end
	f:write("}\n")
	f:close()
end

---@param p tdf.ColorScheme
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
		p.fg.common, -- NormalColor
		p.accent[1], -- HighlightCandidateColor
		p.accent[1], -- HighlightColor
		p.accent,  -- HighlightBackgroundColor
		p.bg.common, -- [InputPanel/Background] Color
		p.bg.border, -- BorderColor
		p.bg.active, -- [InputPanel/Highlight] Color
		asset_root, -- [InputPanel/PrevPage] Image
		asset_root, -- [InputPanel/NextPage] Image
		p.fg.common, -- [Menu] NormalColor
		p.accent[1], -- [Menu] HighlightCandidateColor
		p.bg.common, -- [Menu/Background] Color
		p.bg.border, -- [Menu/Background] BorderColor
		asset_root, -- [Menu/CheckBox] Image
		asset_root, -- [Menu/SubMenu] Image
		p.bg.active, -- [Menu/Highlight] Color
		p.bg.border -- [Menu/Separator] Color
	)

	f:write(content)
	f:close()
end

---@param p tdf.ColorScheme
local function write_nvim(p)
	local syntax_keys = {
		"comment",
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
	bg = {
		common = %q,
  	elevated = %q,
  	hover = %q,
  	active = %q,
  	border = %q,
  	shadow = %q,
	},
  fg = {
		common = %q,
  	muted = %q,
  	subtle = %q,
  	hover = %q,
  	shadow = %q,
	},
	role = {
		error = %q,
		ok = %q,
		warning = %q,
		info = %q,
		hint = %q,
		add  = %q,
		delete = %q,
		change = %q,
	},
  accent = %q,
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
		p.bg.common,
		p.bg.elevated,
		p.bg.hover,
		p.bg.active,
		p.bg.border,
		p.bg.shadow,
		p.fg.common,
		p.fg.muted,
		p.fg.subtle,
		p.fg.hover,
		p.fg.shadow,
		p.role.error,
		p.role.ok,
		p.role.warning,
		p.role.info,
		p.role.hint,
		p.role.add,
		p.role.delete,
		p.role.change,
		p.accent,
		table.concat(accent_lines, "\n"),
		table.concat(syntax_lines, "\n"),
		table.concat(ansi_normal_items, ", "),
		table.concat(ansi_bright_items, ", ")
	)

	f:write(content)
	f:close()

	os.execute("stylua " .. path .. " 2>/dev/null")
end

---@param p tdf.ColorScheme
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

	local gradient_lines = {}
	for i, color in ipairs(s.gradient(p.accent, p.accents[2], 8)) do
		gradient_lines[#gradient_lines + 1] = string.format("gradient_color_%d = '%s'", i, color)
	end

	local content = template:format(p.accent, table.concat(gradient_lines, "\n"))

	local f = assert(io.open(path, "w"))
	f:write(content)
	f:close()
end

---@param p tdf.ColorScheme
local function write_mako(p)
	local path = os.getenv("HOME") .. "/.config/mako/g.colors"
	os.execute("mkdir -p " .. path:match("(.*/)"))
	local template = [[
# Generated from wallpaper

background-color=%s
text-color=%s
border-color=%s
]]
	local content = template:format(p.bg.common, p.fg.common, p.bg.border)
	local f = assert(io.open(path, "w"))
	f:write(content)
	f:close()
end

local M = {}

---@param colors string[]|string hex string list
---@param msg string|nil
function M.dump_console(colors, msg)
	local DOT = " "
	if msg then
		io.write(msg)
	end
	local function dump(hex)
		local r, g, b = h.hex_to_rgb(hex)
		io.write(string.format("\27[38;2;%d;%d;%dm%s", r, g, b, DOT))
	end
	if type(colors) == "string" then
		dump(colors)
	else
		for _, color in ipairs(colors) do
			dump(color)
		end
	end
	io.write("\27[0m\n")
end

---@param colors string[]|string hex string list
---@param msg string|nil
function M.dump_mako(colors, msg)
	local DOT = " "
	local formatted = {}
	if type(colors) == "string" then
		colors = { colors }
	end
	for _, hex in ipairs(colors) do
		local r, g, b = h.hex_to_rgb(hex)
		table.insert(formatted, string.format(
			'<span foreground="#%02x%02x%02x">%s</span>',
			r, g, b, DOT
		))
	end
	local markup = table.concat(formatted, "")
	local cmd = string.format(
		"notify-send '%s' '%s'",
		msg or "Color Preview",
		markup
	)
	os.execute(cmd)
end

---@param p tdf.ColorScheme
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
