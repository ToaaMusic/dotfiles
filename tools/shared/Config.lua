local tdf_root = os.getenv("TOAAM_DOTFILES")
if not tdf_root then
	io.stderr:write("TOAAM_DOTFILES not set\n")
	os.exit(1)
end
local config_path = tdf_root .. "/config.lua"

---@class tdf.Config
---@field components? tdf.Components
---@field color_auto_gen? tdf.ColorAutoGenOpts

---@class tdf.Components
---@field compositor? string|"hypr"
---@field applauncher? string|"rofi"
---@field notify? string|"mako"|"dunst"
---@field terminal? string|"kitty"|"gohstty"
---@field shell? string|"zsh"|"bash"|"fish"

local HOME = os.getenv("HOME")

---@type tdf.Config
local default_config = {
	components = {
		compositor = "hypr",
		applauncher = "rofi",
		notify = "mako",
		terminal = "kitty",
		shell = "zsh",
	},
	color_auto_gen = {
		enable = true,
		notify = true,
		theme_mode = "auto",
		force = {},
		tasks = {
			{
				header = "-- Generated from wallpaper\n-- Do not edit manually!\n\n",
				path = HOME .. "/.config/hypr/hyprland/colors.g.lua",
				type = "lua",
			},
			{
				header = "-- Generated from wallpaper\n-- Do not edit manually!\n\n",
				path = HOME .. "/.config/nvim/lua/colors/g.lua",
				type = "lua"
			},
			{
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
			{
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
			{
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/waybar/styles/colors.g.css",
				type = "gtk_css"
			},
			{
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/gtk-3.0/colors.g.css",
				type = "gtk_css"
			},
			{
				header = "/* Generated from wallpaper\n * Do not edit manually!\n */\n\n",
				path = HOME .. "/.config/gtk-4.0/colors.g.css",
				type = "gtk_css"
			},
			{
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.config/cava/themes/colors.g.theme",
				type = "cava"
			},
			{
				path = HOME .. "/.local/share/fcitx5/themes/auto-gen/theme.conf",
				type = "fcitx5"
			},
			{
				header = "# Generated from wallpaper\n# Do not edit manually!\n\n",
				path = HOME .. "/.config/kitty/colors.g.conf",
				type = "kitty"
			},
			{
				path = HOME .. "/.config/mako/g.colors",
				type = "mako"
			},
		}
	},
}

---helper: merge table and defaults
---@param defaults table
---@param overrides table
---@return table
local function merge(defaults, overrides)
	local result = {}

	for key, default_value in pairs(defaults) do
		local override_value = overrides[key]
		if override_value ~= nil then
			if type(default_value) == "table" and type(override_value) == "table" then
				result[key] = merge(default_value, override_value)
			else
				result[key] = override_value
			end
		else
			result[key] = default_value
		end
	end

	for key, override_value in pairs(overrides) do
		if result[key] == nil then
			result[key] = override_value
		end
	end

	return result
end

local M = {}

---@param config_file_path string
---@return tdf.Config
function M.load(config_file_path)
	local ok, config = pcall(dofile, config_file_path)
	---@cast config tdf.Config
	if ok then
		return merge(default_config, config)
	else
		return default_config
	end
end

---load $TOAAM_DOTFILES/config.lua
---@return tdf.Config
function M.load_tdf_config()
	return M.load(config_path)
end

return M
