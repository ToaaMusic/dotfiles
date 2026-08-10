---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local active_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. scheme.brand:sub(2),
		"_" .. scheme.bg.common:sub(2),
		"_" .. scheme.brand:sub(2),
		"_" .. scheme.brand:sub(2),
		"_" .. scheme.brand:sub(2),
		"_" .. scheme.bg.common:sub(2)
	)
	local inactive_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. scheme.fg.muted:sub(2),
		"_" .. scheme.bg.common:sub(2),
		"_" .. scheme.bg.elevated:sub(2),
		"_" .. scheme.fg.muted:sub(2),
		"_" .. scheme.fg.muted:sub(2),
		"_" .. scheme.bg.common:sub(2)
	)

	local ansi16 = {}
	for i = 0, 7 do
		table.insert(ansi16, string.format("color%d %s\n", i, scheme.ansi_normal[i + 1]))
		table.insert(ansi16, string.format("color%d %s\n", i + 8, scheme.ansi_bright[i + 1]))
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
		scheme.fg.common,
		scheme.bg.common,
		scheme.accents[1],
		scheme.brand,
		scheme.accents[4],
		scheme.accents[1],
		scheme.accents[4],
		scheme.accents[4],
		scheme.bg.border,
		scheme.accents[2],
		scheme.accents[1],
		scheme.brand,
		scheme.fg.muted,
		scheme.bg.elevated,
		scheme.bg.common,
		scheme.accents[1],
		scheme.brand,
		scheme.accents[1],
		scheme.accents[2],
		scheme.accents[1],
		scheme.accents[3],
		ansi16,
		active_template,
		inactive_template
	)

	return content
end
