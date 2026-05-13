-- ENVIRONMENT VARIABLES
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local env = hl.env

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
