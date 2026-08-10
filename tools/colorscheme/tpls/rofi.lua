---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local content = string.format(
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
		scheme.bg.common,
		scheme.fg.common,
		scheme.bg.elevated,
		scheme.bg.hover,
		scheme.bg.active,
		scheme.bg.border,
		scheme.fg.muted,
		scheme.fg.subtle,
		scheme.fg.hover,
		scheme.brand,
		scheme.brand
	)
	for i = 1, 6 do
		content = content .. string.format("    a%d: %s;\n", i, scheme.accents[i])
	end

	content = content .. "}"
	return content
end
