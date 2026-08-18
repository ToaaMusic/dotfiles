local M = {}

local colors_file = os.getenv("HOME") .. "/.config/hypr/hyprland/colors.g.lua"
local colors_file_check = io.open(colors_file)
if colors_file_check then
	colors_file_check:close()
	local scheme            = dofile(colors_file)
	M.active_border_color   = scheme.brand or "rgba(c293a3ff)"
	M.inactive_border_color = scheme.bg.border or "0xff382D2E"
end

return M
