---@param scheme tdf.ColorScheme
---@return string
return function(scheme)
	local tpl = [[
{
  "label": "Auto Gen",
  "light": {
    "fg": "%s",
    "bg": "%s",
    "link": "%s"
  },
  "dark": {
    "fg": "%s",
    "bg": "%s",
    "link": "%s"
  }
}
	]]

	return tpl:format(scheme.fg.common, scheme.bg.common, scheme.brand, scheme.fg.common, scheme.bg.common, scheme.brand)
end
