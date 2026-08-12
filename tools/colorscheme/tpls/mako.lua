---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local template = [[
background-color=%s
text-color=%s
border-color=%s
]]
	local content = template:format(scheme.bg.common, scheme.fg.common, scheme.bg.border)
	return content
end
