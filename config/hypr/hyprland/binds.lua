-- KEYBINDINGS
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local v = require("vars")
local bind = hl.bind
local mainMod = "ALT"
local cmdPath = "$HOME/.config/hypr/cmds/"

--test
bind(mainMod .. " + T", hl.dsp.exec_cmd("notify-send $TOAAM_DOTFILES"))

-- basic
bind(mainMod .. " + Q", hl.dsp.exec_cmd(v.terminal))
bind(mainMod .. " + C", hl.dsp.window.close())
bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
bind(mainMod .. " + P", hl.dsp.window.pseudo())
bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle only

-- apps
bind(mainMod .. " + TAB", hl.dsp.exec_cmd(v.menu))
bind(mainMod .. " + F", hl.dsp.exec_cmd(v.terminal .. " " .. v.fileManager))
bind(mainMod .. " + Z", hl.dsp.exec_cmd(v.terminal .. " " .. v.music))
bind(mainMod .. " + B", hl.dsp.exec_cmd(v.browser))

-- commands (scripts)
bind(mainMod .. " + W", hl.dsp.exec_cmd(cmdPath .. "wall.sh"))
bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(cmdPath .. "wall-gui.sh"))
bind(mainMod .. " + R", hl.dsp.exec_cmd(cmdPath .. "refresh.sh"))
bind(mainMod .. " + H", hl.dsp.exec_cmd(cmdPath .. "toggle-waybar-layout.sh"))
bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- window management
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))
bind(mainMod .. " + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0 }))
bind(mainMod .. " + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0 }))
bind(mainMod .. " + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20 }))
bind(mainMod .. " + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20 }))
bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))
bind(mainMod .. " + SUPER + up", hl.dsp.window.move({ x = "0", y = "-80" }))
bind(mainMod .. " + SUPER + left", hl.dsp.window.move({ x = "-80", y = "0" }))
bind(mainMod .. " + SUPER + down", hl.dsp.window.move({ x = "0", y = "80" }))
bind(mainMod .. " + SUPER + right", hl.dsp.window.move({ x = "80", y = "0" }))

-- workspaces
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("floating"))
bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:floating" }))

for i = 1, 10 do
	local key = i % 10
	bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- media keys
bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),
	{ locked = true, repeating = true }
)
bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),
	{ locked = true, repeating = true }
)
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("playerctl next"), { locked = true })
bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
bind(
	mainMod .. " + equal",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
bind(
	mainMod .. " + minus",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
bind(mainMod .. " + Return", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd("pavucontrol"))
