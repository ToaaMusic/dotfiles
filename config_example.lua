local HOME = os.getenv("HOME")

---@type tdf.Config
return {
	shell_opts = {
		wall_url = "https://api.yppp.net/pc.php"
	},
	color_auto_gen = {
		notify = false,
		theme_mode = "auto",
		syntax_theme = "Material",
		on_reload = function(p)
			if os.getenv("HYPRLAND_INSTANCE_SIGNATURE") then
				os.execute("hyprctl reload config-only")
			else
				os.execute("labwc --reconfigure")
			end
			os.execute("pkill -SIGUSR2 waybar") -- TODO: 不知道为什么waybar的css引用嵌套多了重载没效果，需要手动
			os.execute("makoctl reload >/dev/null 2>&1")
			os.execute("fcitx5 -rd >/dev/null 2>&1")
			os.execute("pkill -SIGUSR1 kitty")
			os.execute("pkill -SIGUSR1 cava")

			if p.dark_mode then
				os.execute("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
			else
				os.execute("gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'")
			end
		end,
		tasks = {
			hypr = {
				header = "-- Generated from wallpaper\n-- Do not edit manually!\n\n",
				path = HOME .. "/.config/hypr/hyprland/colors.g.lua",
				type = "lua",
			},
			nvim = {
				header = "-- Generated from wallpaper\n-- Do not edit manually!\n\n",
				path = HOME .. "/.config/nvim/lua/colors/g.lua",
				type = "lua"
			},
			hyprlang = {
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.config/hypr/colors.g.conf",
				type = "flat",
				flatOpts = {
					kv_sep = " = ",
					prefix = "$",
					format = "16#rgba(%r%g%bff)",
					k_sep = "_",
				}
			},
			rofi = {
				path = HOME .. "/.config/rofi/colors.g.rasi",
				type = "flat",
				flatOpts = {
					f_sep = "-",
					kv_sep = ": ",
					terminator = ";",
					indent = 2
				},
				header = "* {\n",
				footer = "\n}",
			},
			waybar = {
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/waybar/styles/colors.g.css",
				type = "gtk_css"
			},
			gtk3 = {
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/gtk-3.0/colors.g.css",
				type = "gtk_css"
			},
			gtk4 = {
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/gtk-4.0/colors.g.css",
				type = "gtk_css"
			},
			foliate = {
				path = HOME .. "/.config/com.github.johnfactotum.Foliate/themes/autogen.json",
				type = "foliate"
			},
			cava = {
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.config/cava/themes/colors.g.theme",
				type = "cava"
			},
			kitty = {
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.config/kitty/colors.g.conf",
				type = "kitty"
			},
			mako = {
				path = HOME .. "/.config/mako/g.colors",
				type = "mako"
			},
			labwc = {
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.local/share/themes/auto_gen/labwc/themerc",
				type = "labwc"
			},
			fcitx5 = {
				path = HOME .. "/.local/share/fcitx5/themes/auto-gen/theme.conf",
				type = "fcitx5"
			},
			yazi = {
				path = HOME .. "/.config/yazi/flavors/g.yazi/flavor.toml",
				type = "yazi"
			},
		},
	}
}
