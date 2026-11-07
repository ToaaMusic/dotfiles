-- rules.lua
-- WINDOW & WORKSPACE RULES
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local wr = hl.window_rule
local wsr = hl.workspace_rule
local lr = hl.layer_rule

-- Example window rules that are useful

-- Ignore maximize requests from all apps
wr({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

-- Fix some dragging issues with XWayland
wr({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Hyprland-run windowrule
wr({ name = "move-hyprland-run", match = { class = "hyprland-run" }, move = "20 monitor_h-120", float = true })

-- custom

-- Waydroid: fullscreen automatically
wr({ name = "waydroid-fullscreen", match = { class = "Waydroid" }, fullscreen = true })

-- Borderless workspace w[tv1]
wsr({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
wr({ name = "no-border-wtv1", match = { float = false, workspace = "w[tv1]" }, border_size = 0, rounding = 0 })

-- Set workspace 1 scrolling layout
wsr({ workspace = "1", layout = "scrolling" })

-- no_blur
wr({ name = "no-blur-ebrain", match = { class = "EbrainAI.Linux" }, no_blur = true })
wr({ name = "no-blur-ebrain-title", match = { title = "ebrain-ai" }, no_blur = true })

-- floating
local float_size = { "(monitor_w*0.75)", "(monitor_h*0.75)" }
-- wr({ match = { class = "kitty" }, center = true, float = true, size = float_size })
wr({ match = { title = "Volume Control" }, center = true, float = true, size = { "(monitor_w*0.50)", "(monitor_h*0.25)" } })
wr({ match = { title = "^(Yazi:)(.*)$" }, center = true, float = true, size = float_size })
wr({ match = { title = "termfilechooser" }, center = true, float = true, size = float_size })

-- picture-in-picture
wr({
	name = "picture-in-picture",
	match = {
		title = "^([Pp]icture[-\\s]?[Ii]n[-\\s]?[Pp]icture)(.*)$",
	},
	float = true,
	pin = true,
	keep_aspect_ratio = true,
	size = { "(monitor_w*0.25)", "(monitor_h*0.25)" },
	move = { "(monitor_w*0.73)", "(monitor_h*0.72)" },
})

-- cava
wr({
	name = "pin-cava",
	match = { class = "cava" },
	move = "0 monitor_h-100+8",
	size = { "(monitor_w)", 100 },
	float = true,
	pin = true,
	no_shadow = true,
	no_blur = true,
	border_size = 0,
	rounding = 0,
	--no events
	no_focus = true,
	no_follow_mouse = true,
})

-- layer rule
lr({ match = { namespace = "notifications" }, animation = "slide right" })
lr({ match = { namespace = "rofi" }, animation = "slide bottom" })
