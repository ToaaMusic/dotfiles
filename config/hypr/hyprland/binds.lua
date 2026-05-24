-- KEYBINDINGS
-- See https://wiki.hypr.land/Configuring/Basics/Binds/

return function(V)
  local mainMod = "ALT"
  local cmdPath = "$HOME/.config/hypr/cmds/"

  --test
  hl.bind(mainMod .. " + T",   hl.dsp.exec_cmd("notify-send $TOAAM_DOTFILES"))

  -- basic
  hl.bind(mainMod .. " + Q",   hl.dsp.exec_cmd(V.terminal))
  hl.bind(mainMod .. " + C",   hl.dsp.window.close())
  hl.bind(mainMod .. " + V",   hl.dsp.window.float({ action = "toggle" }))
  hl.bind(mainMod .. " + M",   hl.dsp.exec_cmd("hyprctl dispatch exit"))
  hl.bind(mainMod .. " + P",   hl.dsp.window.pseudo())
  hl.bind(mainMod .. " + J",   hl.dsp.layout("togglesplit"))    -- dwindle only

  -- apps
  hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd(V.menu))
  hl.bind(mainMod .. " + F",   hl.dsp.exec_cmd(V.terminal .. " " .. V.fileManager))
  hl.bind(mainMod .. " + Z",   hl.dsp.exec_cmd(V.terminal .. " " .. V.music))
  hl.bind(mainMod .. " + B",   hl.dsp.exec_cmd(V.browser))

  -- commands (scripts)
  hl.bind(mainMod .. " + W",           hl.dsp.exec_cmd(cmdPath .. "wall.sh"))
  hl.bind(mainMod .. " + SHIFT + W",   hl.dsp.exec_cmd(cmdPath .. "wall-gui.sh"))
  hl.bind(mainMod .. " + R",           hl.dsp.exec_cmd(cmdPath .. "refresh.sh"))
  hl.bind(mainMod .. " + H",           hl.dsp.exec_cmd(cmdPath .. "toggle-waybar-layout.sh"))
  hl.bind("Print",                     hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

  -- window management
  hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
  hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
  hl.bind(mainMod .. " + left",      hl.dsp.focus({ direction = "left" }))
  hl.bind(mainMod .. " + right",     hl.dsp.focus({ direction = "right" }))
  hl.bind(mainMod .. " + up",        hl.dsp.focus({ direction = "up" }))
  hl.bind(mainMod .. " + down",      hl.dsp.focus({ direction = "down" }))
  hl.bind(mainMod .. " + CTRL + left",   hl.dsp.window.resize({ x = -20, y = 0 }))
  hl.bind(mainMod .. " + CTRL + right",  hl.dsp.window.resize({ x = 20,  y = 0 }))
  hl.bind(mainMod .. " + CTRL + up",     hl.dsp.window.resize({ x = 0,   y = -20 }))
  hl.bind(mainMod .. " + CTRL + down",   hl.dsp.window.resize({ x = 0,   y = 20 }))
  hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
  hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
  hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
  hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
  hl.bind(mainMod .. " + SUPER + up",    hl.dsp.window.move({ x = "0", y = "-80" }))
  hl.bind(mainMod .. " + SUPER + left",  hl.dsp.window.move({ x = "-80", y = "0" }))
  hl.bind(mainMod .. " + SUPER + down",  hl.dsp.window.move({ x = "0", y = "80" }))
  hl.bind(mainMod .. " + SUPER + right", hl.dsp.window.move({ x = "80", y = "0" }))

  -- workspaces
  hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
  hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
  hl.bind(mainMod .. " + S",          hl.dsp.workspace.toggle_special("floating"))
  hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.window.move({ workspace = "special:floating" }))

  for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,           hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key,   hl.dsp.window.move({ workspace = i }))
  end

  -- media keys
  hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),    { locked = true, repeating = true })
  hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })
  hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true, repeating = true })
  hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                     { locked = true, repeating = true })
  hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                     { locked = true, repeating = true })

  hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("playerctl next"),       { locked = true })
  hl.bind(mainMod .. " + bracketleft",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
  hl.bind("XF86AudioNext",              hl.dsp.exec_cmd("playerctl next"),       { locked = true })
  hl.bind("XF86AudioPause",             hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPlay",              hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
  hl.bind("XF86AudioPrev",              hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
end
