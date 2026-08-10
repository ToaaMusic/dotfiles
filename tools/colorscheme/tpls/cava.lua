local s = require("strategy")

---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local template = [[
[color]
background = default
foreground = '%s'
gradient = 1
%s
]]

	local gradient_lines = {}
	for i, color in ipairs(s.gradient(scheme.brand, scheme.accents[2], 8)) do
		gradient_lines[#gradient_lines + 1] = string.format("gradient_color_%d = '%s'", i, color)
	end

	local content = template:format(scheme.brand, table.concat(gradient_lines, "\n"))

	return content
end
