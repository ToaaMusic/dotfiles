---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local tpl = [[
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

/* role */
@define-color error %s;
@define-color ok %s;
@define-color warning %s;
@define-color info %s;
@define-color hint %s;

/* accents */
@define-color a %s;

]]
	local content = tpl:format(
		scheme.bg.common,
		scheme.bg.elevated,
		scheme.bg.hover,
		scheme.bg.active,
		scheme.bg.border,
		scheme.bg.shadow,
		scheme.fg.common,
		scheme.fg.hover,
		scheme.fg.muted,
		scheme.fg.subtle,
		scheme.fg.shadow,
		scheme.role.error,
		scheme.role.ok,
		scheme.role.warning,
		scheme.role.info,
		scheme.role.hint,
		scheme.brand
	)
	for i = 1, 6 do
		content = content .. string.format("@define-color a%d %s;\n", i, scheme.accents[i])
	end
	return content
end
