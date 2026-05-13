-- WINDOW & WORKSPACE RULES
-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- See https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Ignore maximize requests from all apps
hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
hl.window_rule({
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
hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

-- Borderless workspace w[tv1]
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.window_rule({
	name = "no-border-wtv1",
	match = { float = false, workspace = "w[tv1]" },
	border_size = 0,
	rounding = 0,
})

-- Workspace 1: scrolling layout, direction right
hl.workspace_rule({ workspace = "1", layout = "scrolling" })

-- no_blur for specific window classes
hl.window_rule({
	name = "no-blur-ebrain",
	match = { class = "EbrainAI.Linux" },
	no_blur = true,
})
hl.window_rule({
	name = "no-blur-ebrain-title",
	match = { title = "ebrain-ai" },
	no_blur = true,
})
hl.window_rule({
	name = "no-blur-cava",
	match = { title = "cava" },
	no_blur = true,
})
