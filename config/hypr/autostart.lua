-- AUTOSTART
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

return function(V)
  hl.on("hyprland.start", function()
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprsunset")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("fcitx5 --replace -d")
    hl.exec_cmd(V.browser)
  end)
end
