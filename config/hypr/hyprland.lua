-- Hyprland Lua configuration
-- Converted from hyprlang config, Hyprland >= 0.55.0
-- https://wiki.hypr.land/Configuring/Start/
--
-- See hyprland_default.lua for the official default config reference

-- Load sub-modules (variables / my programs)
-- Side-effect modules
require("env")
require("rules")

-- Values module
local V = require("vars")

-- Load color overrides if generated
local colors_file = os.getenv("HOME") .. "/.config/hypr/colors.g.lua"
local colors_file_check = io.open(colors_file)
if colors_file_check then
	colors_file_check:close()
	local colors = dofile(colors_file)
	V.active_border_color = colors.active_border_color or V.active_border_color
	V.inactive_border_color = colors.inactive_border_color or V.inactive_border_color
end

---------------------
---- MONITORS -------
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "1920x0",
	scale = 1,
})
hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@120",
	position = "0x0",
	scale = 1,
	mirror = "eDP-1",
})

----------------------
---- LOOK AND FEEL ----
----------------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
	general = {
		gaps_in = 2,
		gaps_out = 2,

		border_size = 2,

		-- https://wiki.hypr.land/0.54.0/Configuring/Variables for info about colors
		col = {
			active_border = { colors = { V.active_border_color, V.active_border_color }, angle = 45 },
			inactive_border = V.inactive_border_color,
		},

		resize_on_border = false,

		-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/
		allow_tearing = false,

		layout = "dwindle",

		snap = {
			enabled = false,
			respect_gaps = true,
		},
	},

	decoration = {
		rounding = 10,
		rounding_power = 3.0,

		active_opacity = 1.0,
		inactive_opacity = 0.8,

		border_part_of_window = false,

		screen_shader = "~/.config/hypr/shaders/movie.frag",

		shadow = {
			enabled = false,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},

		blur = {
			enabled = true,
			size = 6,
			passes = 3,
			xray = true,
			noise = 0.13,
			contrast = 0.8916,
			brightness = 0.8172,
			vibrancy = 0.2,
			vibrancy_darkness = 0,

			popups = true,
			input_methods = true,
		},
	},

	animations = {
		enabled = true,
		workspace_wraparound = true,
	},
})

-- Curves (mirroring your old hyprlang config exactly)
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Animations (mirroring your old hyprlang config)
hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 4.79,
	bezier = "easeOutQuint",
	style = "slidefadevert 87%",
})
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 2,
	bezier = "easeInOutCubic",
	style = "slidefadevert top 100%",
})
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 2, bezier = "easeInOutCubic", style = "slide" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

-- Layouts
-- https://wiki.hypr.land/Configuring/Layouts/
hl.config({
	dwindle = {
		preserve_split = true,
	},

	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.75,
	},

	master = {
		new_status = "master",
	},
})

-- XWayland
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/XWayland/
hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

----------------
----  MISC  ----
----------------

hl.config({
	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

----------------
---- INPUT  ----
----------------

-- https://wiki.hypr.land/Configuring/Basics/Variables/#input
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		follow_mouse = 1,
		sensitivity = 0,

		touchpad = {
			natural_scroll = false,
		},
	},
})

-- Gestures
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

-- Per-device configs
-- https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/
hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

hl.device({
	name = "compx-2.4g-wireless-receiver",
	repeat_delay = 250,
	repeat_rate = 40,
})

hl.device({
	name = "compx-2.4g-wireless-receiver-keyboard",
})

hl.device({
	name = "compx-2.4g-wireless-receiver-consumer-control",
})

--------------------------
---- LOAD BINDS & AUTOSTART ----
--------------------------

-- Load binds
local binds_mod = require("binds")
binds_mod(V)

-- Load autostart
local autostart_mod = require("autostart")
autostart_mod(V)

-- Plugins (commented out by default, same as old config)
-- Uncomment to enable:
-- require("plugins")
