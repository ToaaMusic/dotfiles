local tdf_root = os.getenv("TOAAM_DOTFILES")
if not tdf_root then
	io.stderr:write("TOAAM_DOTFILES not set\n")
	os.exit(1)
end
local config_path = tdf_root .. "/config.lua"

---@class tdf.Config
---@field components? tdf.Components
---@field link? tdf.LinkConfig
---@field color_auto_gen? tdf.ColorAutoGenConfig

---@class tdf.Components
---@field compositor? string|"hypr"
---@field applauncher? string|"rofi"
---@field notify? string|"mako"|"dunst"
---@field terminal? string|"kitty"|"gohstty"
---@field shell? string|"zsh"|"bash"|"fish"

---@class tdf.LinkConfig
---@field enable? boolean

---@class tdf.ColorAutoGenConfig
---@field enable? boolean
---@field notify? boolean
---@field dark_mode? "auto"|"day"|"night"
---@field tasks? GenerationTask[]

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
		dark_mode = "auto",
		tasks = {
			{
				header = [[
-- Generated from wallpaper
-- Do not edit manually!

		]],
				path = HOME .. "/.config/hypr/hyprland/colors.g.lua",
				type = "hypr",
			},
			{
				path = HOME .. "/.config/nvim/lua/colors/g.lua",
				type = "lua"
			},
			{
				path = HOME .. "/.config/cava/themes/colors.g.theme",
				type = "cava"
			},
			{
				path = HOME .. "/.local/share/fcitx5/themes/auto-gen/theme.conf",
				type = "fcitx5"
			},
			{
				path = HOME .. "/.config/kitty/colors.g.conf",
				type = "kitty"
			},
			{
				path = HOME .. "/.config/mako/g.colors",
				type = "mako"
			},
			{
				path = HOME .. "/.config/rofi/colors.g.rasi",
				type = "rofi"
			},
			{
				path = HOME .. "/.config/waybar/styles/colors.g.css",
				type = "waybar"
			}
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
	return M.load(os.getenv("TOAAM_DOTFILES") .. "/config.lua")
end

function M.serialize_lua_value(v)
	if type(v) == "boolean" then
		return v and "true" or "false"
	elseif type(v) == "string" then
		return string.format("%q", v)
	else
		return tostring(v)
	end
end

---@param config tdf.Config
function M.save(config)
	local L = {}
	L[#L + 1] = "---@type tdf.Config"
	L[#L + 1] = "return {"
	local I = "  "

	local c = config.color_auto_gen

	if c then
		local changed = (c.enable ~= true or c.notify ~= true or c.dark_mode ~= "auto")
		if changed then
			L[#L + 1] = I .. "color_auto_gen = {"
			L[#L + 1] = I .. I .. "enable = " .. M.serialize_lua_value(c.enable) .. ","
			L[#L + 1] = I .. I .. "notify = " .. M.serialize_lua_value(c.notify) .. ","
			L[#L + 1] = I .. I .. "day_mode = " .. string.format("%q", c.dark_mode) .. ","
			L[#L + 1] = I .. "},"
		end
	end

	local defaults = { compositor = "hypr", applauncher = "rofi", notify = "mako", terminal = "kitty", shell = "zsh" }
	for _, k in ipairs({ "compositor", "applauncher", "notify", "terminal", "shell" }) do
		if config[k] ~= defaults[k] then
			L[#L + 1] = I .. k .. " = " .. string.format("%q", config[k]) .. ","
		end
	end
	L[#L + 1] = "}"
	local f = io.open(config_path, "w")
	if f then
		f:write(table.concat(L, "\n") .. "\n")
		f:close()
		print("Saved to " .. config_path)
	else
		print("ERROR: cannot write " .. config_path)
	end
end

-- local config = M.load_tdf()
-- print(config.shell)

return M
