--#region def
---@class tdf.Config
---@field link? tdf.LinkConfig
---@field compositor? string|"hypr"
---@field applauncher? string|"rofi"
---@field notify? string|"mako"|"dunst"
---@field terminal? string|"kitty"|"gohstty"
---@field shell? string|"zsh"|"bash"|"fish"
---@field color_auto_gen? tdf.ColorAutoGenConfig

---@class tdf.LinkConfig
---@field enable? boolean

---@class tdf.ColorAutoGenConfig
---@field enable? boolean
---@field notify? boolean
---@field day_mode? "auto"|"day"|"night"

---@type tdf.Config
local default_config = {
	compositor = "hypr",
	applauncher = "rofi",
	notify = "mako",
	terminal = "kitty",
	shell = "zsh",
	color_auto_gen = {
		enable = true,
    notify = true,
		day_mode = "auto",
	},
}
--#endregion

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
function M.load_tdf()
	return M.load(os.getenv("TOAAM_DOTFILES") .. "/config.lua")
end

-- local config = M.load_tdf()
-- print(config.shell)
return M
