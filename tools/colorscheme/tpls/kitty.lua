---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local brand_no_hash = scheme.brand:sub(2)
	local bg_no_hash = scheme.bg.common:sub(2)
	local fg_muted_no_hash = scheme.fg.muted:sub(2)
	local bg_elevated_no_hash = scheme.bg.elevated:sub(2)

	local active_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. brand_no_hash,
		"_" .. bg_no_hash,
		"_" .. bg_no_hash,
		"_" .. brand_no_hash,
		"_" .. brand_no_hash,
		"_" .. bg_no_hash
	)
	local inactive_template = string.format(
		"{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
		"_" .. fg_muted_no_hash,
		"_" .. bg_no_hash,
		"_" .. bg_elevated_no_hash,
		"_" .. fg_muted_no_hash,
		"_" .. fg_muted_no_hash,
		"_" .. bg_no_hash
	)

	local ansi_lines = {}
	for i = 0, 7 do
		ansi_lines[#ansi_lines + 1] = string.format("color%d %s", i, scheme.ansi_normal[i + 1])
		ansi_lines[#ansi_lines + 1] = string.format("color%d %s", i + 8, scheme.ansi_bright[i + 1])
	end

	local template = [[
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
		scheme.bg.common,
		scheme.brand,
		scheme.accents[4],
		scheme.bg.common,
		scheme.accents[4],
		scheme.accents[4],
		scheme.bg.border,
		scheme.accents[2],
		scheme.bg.common,
		scheme.brand,
		scheme.fg.muted,
		scheme.bg.elevated,
		scheme.bg.common,
		scheme.bg.common,
		scheme.brand,
		scheme.bg.common,
		scheme.accents[2],
		scheme.bg.common,
		scheme.accents[3],
		table.concat(ansi_lines, "\n"),
		active_template,
		inactive_template
	)

	return content
end
