---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local content = [[
return {
  active_border_color = "rgba(%sff)",
  inactive_border_color = "%s",
}
]]
	return content:format(scheme.brand:sub(2), scheme.bg.border)
end
