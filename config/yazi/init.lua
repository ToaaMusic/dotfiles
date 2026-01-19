-- ~/.config/yazi/init.lua
function Linemode:custom_linemode()
	local size = self._file:size()
	return string.format("|%s", size and ya.readable_size(size) or "-")
end