-- Config.lua

---@class tdf.Config
---@field components? tdf.Components
---@field color_auto_gen? tdf.ColorAutoGenOpts
---@field shell_opts? tdf.ShellOpts

-- TODO: NOT supported yet.
---@class tdf.Components
---@field compositor? string|"hypr"
---@field applauncher? string|"rofi"
---@field notify? string|"mako"|"dunst"
---@field terminal? string|"kitty"|"gohstty"
---@field shell? string|"zsh"|"bash"|"fish"

---@class tdf.ShellOpts
---@field wall_url? string

---@type tdf.Config
local default_config = {
	shell_opts = {
		-- https://api.yppp.net/pc.php
		-- https://api.paugram.com/wallpaper/
		-- http://www.98qy.com/sjbz/api.php
		-- https://api.bimg.cc/random?w=1920&h=1080
		-- https://ntbg.app/
		wall_url = "https://api.yppp.net/pc.php"
	},
	components = {},
	color_auto_gen = {
		enable = true,
		notify = true,
		theme_mode = "auto",
		force = {},
		tasks = {},
	},
}

---helper: merge table and defaults
---@param defaults table
---@param overrides table
---@return table new a new table
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

---load config from a given file path.
---@param config_file_path string
---@return tdf.Config final_config if loaded successfully or default config otherwise
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
	local tdf_root = os.getenv("TOAAM_DOTFILES")
	if not tdf_root then
		io.stderr:write("TOAAM_DOTFILES not set\n")
		os.exit(1)
	end
	local config_path = tdf_root .. "/config.lua"
	return M.load(config_path)
end

---@param opt_name string
local function get_shell_opt(opt_name)
	local config = M.load_tdf_config()
	return config.shell_opts[opt_name]
end

if arg then
	print(get_shell_opt(arg[1]))
end

return M
