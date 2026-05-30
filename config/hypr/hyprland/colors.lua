local M = {}

-- color defaults (overridden by colors.g.lua if generated)
M.active_border_color   = "rgba(c293a3ff)"
M.inactive_border_color = "0xff382D2E"

local colors_file = os.getenv("HOME") .. "/.config/hypr/hyprland/colors.g.lua"
local colors_file_check = io.open(colors_file)
if colors_file_check then
	colors_file_check:close()
	local colors = dofile(colors_file)
	M.active_border_color = colors.active_border_color or M.active_border_color
	M.inactive_border_color = colors.inactive_border_color or M.inactive_border_color
end

return M
