-- ENVIRONMENT VARIABLES
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local env = hl.env

-- Derive dotfiles project path from symlink
-- ~/.config/hypr -> .../dotfiles/config/hypr -> dotfiles root is two levels up
local function derive_dotfiles_root()
	local home = os.getenv("HOME")
	if not home then return end
	local hypr_config = home .. "/.config/hypr"
	local handle = io.popen("readlink -f " .. "'" .. hypr_config .. "'")
	if not handle then return end
	local realpath = handle:read("*l")
	handle:close()
	if not realpath then return end
	-- realpath = /path/to/dotfiles/config/hypr
	-- dotfiles root = /path/to/dotfiles
	return realpath:match("^(.*)/config/[^/]+$")
end

local dotfiles = derive_dotfiles_root()
if dotfiles then
	env("TOAAM_DOTFILES", dotfiles)
end

-- cursor
env("XCURSOR_SIZE", "24")
env("HYPRCURSOR_SIZE", "24")
env("XCURSOR_THEME", "Imouto")

-- nvidia
env("LIBVA_DRIVER_NAME", "nvidia")
env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")

-- qt
env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- xdg
env("XDG_CURRENT_DESKTOP", "Hyprland")
env("XDG_SESSION_TYPE", "wayland")
env("XDG_SESSION_DESKTOP", "Hyprland")

-- wayland
env("GDK_BACKEND", "wayland,x11,*")
env("QT_QPA_PLATFORM", "wayland;xcb")
env("SDL_VIDEODRIVER", "wayland")
env("CLUTTER_BACKEND", "wayland")

