-- VARIABLES
-- See https://wiki.hypr.land/Configuring/Basics/Variables/

local M = {}

M.terminal    = "kitty"
M.fileManager = "yazi"
M.menu        = "rofi -show drun"
M.music       = "musicfox"
M.browser     = "zen"
M.editor      = "zeditor"
M.ide         = "rider"

-- color defaults (overridden by colors.lua if generated)
M.active_border_color   = "rgba(c293a3ff)"
M.inactive_border_color = "0xff382D2E"

return M
