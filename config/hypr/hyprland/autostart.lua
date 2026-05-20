-- AUTOSTART
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

return function(V)
	hl.on("hyprland.start", function()
		-- hl.exec_cmd("waybar")
		hl.exec_cmd("fcitx5 --replace -d")
		hl.exec_cmd(V.browser)
		hl.exec_cmd("$TOAAM_DOTFILES/scripts/start-hyprpaper.sh")
    hl.exec_cmd("hyprctl setcursor Imouto 28")
	end)
end
