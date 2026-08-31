-- KEYBINDINGS
-- See https://wiki.hypr.land/Configuring/Basics/Binds/
local v = require("vars")
local bind = hl.bind
local mainMod = "SUPER"
local primMod = "ALT"
local main_prim = mainMod .. " + " .. primMod
local cmdPath = "$HOME/.config/hypr/cmds/"

local function set_binds(binds)
	for k, va in pairs(binds) do
		if type(va) == "table" then
			bind(k, va[1], va[2])
		else
			bind(k, va)
		end
	end
end

local hyprshutdown_cmd = "command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"

---@type table<string, function|HL.Dispatcher|{[1]: function|HL.Dispatcher, [2]: HL.BindOptions}>
local bind_map = {
	-- basic
	[mainMod .. " + Q"]              = hl.dsp.exec_cmd(v.terminal),
	[mainMod .. " + SHIFT + Q"]      = hl.dsp.exec_cmd("kitten quick-access-terminal"),
	[mainMod .. " + C"]              = hl.dsp.window.close(),
	[mainMod .. " + M"]              = hl.dsp.exec_cmd(hyprshutdown_cmd),
	[mainMod .. " + V"]              = hl.dsp.window.float({ action = "toggle" }),
	[mainMod .. " + P"]              = hl.dsp.window.pseudo(),
	[mainMod .. " + J"]              = hl.dsp.layout("togglesplit"),       -- dwindle only

	-- apps
	[mainMod .. " + TAB"]            = hl.dsp.exec_cmd(v.menu),
	[mainMod .. " + F"]              = hl.dsp.exec_cmd(v.terminal .. " " .. v.fileManager),
	[mainMod .. " + Z"]              = hl.dsp.exec_cmd(v.terminal .. " " .. v.music),
	[mainMod .. " + B"]              = hl.dsp.exec_cmd(v.browser),

	-- scripts
	[mainMod .. " + W"]              = hl.dsp.exec_cmd(cmdPath .. "wall.sh"),
	[mainMod .. " + SHIFT + W"]      = hl.dsp.exec_cmd(cmdPath .. "wall-gui.sh"),
	[mainMod .. " + R"]              = hl.dsp.exec_cmd(cmdPath .. "refresh.sh"),
	[mainMod .. " + H"]              = hl.dsp.exec_cmd(cmdPath .. "switch-waybar.sh"),
	[mainMod .. " + SHIFT + H"]      = hl.dsp.exec_cmd("~/.config/waybar/scripts/change-bar.sh winlike"),
	["Print"]                        = hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'),

	-- window management
	[mainMod .. " + left"]           = hl.dsp.focus({ direction = "left" }),
	[mainMod .. " + right"]          = hl.dsp.focus({ direction = "right" }),
	[mainMod .. " + up"]             = hl.dsp.focus({ direction = "up" }),
	[mainMod .. " + down"]           = hl.dsp.focus({ direction = "down" }),
	[mainMod .. " + mouse:272"]      = { hl.dsp.window.drag(), { mouse = true } },
	[mainMod .. " + mouse:273"]      = { hl.dsp.window.resize(), { mouse = true } },
	[mainMod .. " + CTRL + left"]    = { hl.dsp.window.resize({ x = -20, y = 0, relative = true }), { repeating = true } },
	[mainMod .. " + CTRL + right"]   = { hl.dsp.window.resize({ x = 20, y = 0, relative = true }), { repeating = true } },
	[mainMod .. " + CTRL + up"]      = { hl.dsp.window.resize({ x = 0, y = -20, relative = true }), { repeating = true } },
	[mainMod .. " + CTRL + down"]    = { hl.dsp.window.resize({ x = 0, y = 20, relative = true }), { repeating = true } },
	[mainMod .. " + SHIFT + left"]   = hl.dsp.window.move({ direction = "left" }),
	[mainMod .. " + SHIFT + right"]  = hl.dsp.window.move({ direction = "right" }),
	[mainMod .. " + SHIFT + up"]     = hl.dsp.window.move({ direction = "up" }),
	[mainMod .. " + SHIFT + down"]   = hl.dsp.window.move({ direction = "down" }),
	[main_prim .. "+left"]           = { hl.dsp.window.move({ x = "-80", y = "0", relative = true }), { repeating = true } },
	[main_prim .. "+right"]          = { hl.dsp.window.move({ x = "80", y = "0", relative = true }), { repeating = true } },
	[main_prim .. "+up"]             = { hl.dsp.window.move({ x = "0", y = "-80", relative = true }), { repeating = true } },
	[main_prim .. "+down"]           = { hl.dsp.window.move({ x = "0", y = "80", relative = true }), { repeating = true } },

	-- workspaces
	[mainMod .. " + mouse_down"]     = hl.dsp.focus({ workspace = "e+1" }),
	[mainMod .. " + mouse_up"]       = hl.dsp.focus({ workspace = "e-1" }),
	[mainMod .. " + S"]              = hl.dsp.workspace.toggle_special("floating"),
	[mainMod .. " + SHIFT + S"]      = hl.dsp.window.move({ workspace = "special:floating" }),

	-- media keys
	["XF86AudioRaiseVolume"]         = { hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true } },
	["XF86AudioLowerVolume"]         = { hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true } },
	["XF86AudioMute"]                = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true } },
	["XF86AudioMicMute"]             = { hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true } },
	["XF86MonBrightnessUp"]          = { hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true } },
	["XF86MonBrightnessDown"]        = { hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true } },
	["XF86AudioNext"]                = { hl.dsp.exec_cmd("playerctl next"), { locked = true } },
	["XF86AudioPause"]               = { hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	["XF86AudioPlay"]                = { hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	["XF86AudioPrev"]                = { hl.dsp.exec_cmd("playerctl previous"), { locked = true } },

	[mainMod .. " + bracketright"]   = { hl.dsp.exec_cmd("playerctl next"), { locked = true } },
	[mainMod .. " + bracketleft"]    = { hl.dsp.exec_cmd("playerctl previous"), { locked = true } },
	[mainMod .. " + equal"]          = { hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true } },
	[mainMod .. " + minus"]          = { hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true } },
	[mainMod .. " + SHIFT + Return"] = { hl.dsp.exec_cmd("playerctl play-pause"), { locked = true } },
	[mainMod .. " + SHIFT + P"]      = hl.dsp.exec_cmd("pavucontrol"),
}

for i = 1, 10 do
	local key = i % 10
	bind_map[mainMod .. " + " .. key] = hl.dsp.focus({ workspace = i })
	bind_map[mainMod .. " + SHIFT + " .. key] = hl.dsp.window.move({ workspace = i })
end

set_binds(bind_map)

-- game mode
bind(mainMod .. " + Escape", hl.dsp.submap("game"))
bind("ALT + Escape", hl.dsp.submap("game"))
hl.define_submap("game", function()
	bind("Escape", hl.dsp.submap("reset"))
end)
