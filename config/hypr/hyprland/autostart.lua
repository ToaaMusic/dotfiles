-- AUTOSTART
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local v = require("vars")
local run = hl.exec_cmd

hl.on("hyprland.start", function()
	-- run("waybar")
	run("fcitx5 --replace -d")
	run(v.browser)
	run("$TOAAM_DOTFILES/scripts/start-hyprpaper.sh")
	run("hyprctl setcursor Imouto 28")
end)
