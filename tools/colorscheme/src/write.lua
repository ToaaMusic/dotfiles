-- write.lua
-- write tdf.ColorScheme to config files

---@param val any
---@param indent number|nil
---@return string
local function serialize_lua(val, indent)
	indent = indent or 0
	local function indent_str()
		return string.rep("  ", indent)
	end

	local function serialize_value(v, level)
		if type(v) == "nil" then
			return "nil"
		elseif type(v) == "string" then
			return string.format("%q", v)
		elseif type(v) == "number" then
			return tostring(v)
		elseif type(v) == "boolean" then
			return v and "true" or "false"
		elseif type(v) == "table" then
			-- Check if it's a list-like table (array)
			local is_list = true
			local max_key = 0
			for k, _ in pairs(v) do
				if type(k) ~= "number" or k <= 0 then
					is_list = false
					break
				end
				if k > max_key then max_key = k end
			end
			-- Check if keys are sequential starting from 1
			if is_list then
				for i = 1, max_key do
					if v[i] == nil then
						is_list = false
						break
					end
				end
			end

			if is_list and max_key > 0 then
				-- Array-style table: { "a", "b", "c" }
				local items = {}
				for i = 1, max_key do
					items[i] = serialize_value(v[i], level)
				end
				return "{" .. table.concat(items, ", ") .. "}"
			else
				-- Map-style table: { key = "value", ... }
				local keys = {}
				for k, _ in pairs(v) do
					if type(k) == "number" and k > 0 and v[k] ~= nil then
						keys[#keys + 1] = { key = k, str = "[" .. k .. "]" }
					elseif type(k) == "string" and k:match("^[%a_][%w_]*$") then
						keys[#keys + 1] = { key = k, str = k }
					else
						keys[#keys + 1] = { key = k, str = "[" .. serialize_value(k, level) .. "]" }
					end
				end
				table.sort(keys, function(a, b) return tostring(a.key) < tostring(b.key) end)

				if #keys == 0 then
					return "{}"
				end

				local lines = {}
				for _, item in ipairs(keys) do
					local val_str = serialize_value(v[item.key], level + 1)
					lines[#lines + 1] = indent_str() .. "  " .. item.str .. " = " .. val_str .. ","
				end
				return "{\n" .. table.concat(lines, "\n") .. "\n" .. indent_str() .. "}"
			end
		else
			return tostring(v)
		end
	end

	return serialize_value(val, indent)
end

--#region
---@diagnostic disable: unused-local
---@diagnostic disable: unused-function

---@class GenerationTask
---@field path string The target path
---@field type? string|"lua"|"gtk_css" The type of file to generate, which decides the build-in generation function to use
---@field func? fun(p:tdf.ColorScheme):string Your custom function to generate
---@field header? string The header content of the file to be generated
local GenerationTask = {}
GenerationTask.__index = GenerationTask

---@param path string
---@param func fun(p:tdf.ColorScheme)
---@param header string|nil
function GenerationTask:new(path, func, header)
	---@type GenerationTask
	local obj = {
		path = path,
		func = func,
		header = header
	}
	return setmetatable(obj, GenerationTask)
end

---@param self GenerationTask
---@param scheme tdf.ColorScheme
function GenerationTask:run(scheme)
	local path = self.path
	local func = self.func
	local header = self.header or ""
	local t_type = self.type
	os.execute("mkdir -p " .. path:match("(.*/)"))
	local f = assert(io.open(path, "w"))
	local content
	if func ~= nil then
		content = func(scheme)
	elseif t_type == "lua" then
		content = "return " .. serialize_lua(scheme)
	elseif t_type ~= nil then
		local tpl = require("tpls." .. t_type)
		content = tpl(scheme)
	else
		content = ""
	end
	f:write(header .. content)
	f:close()
	if t_type == "lua" then
		os.execute("stylua " .. path .. " 2>/dev/null")
	end
end

---@diagnostic enable: unused-local
---@diagnostic enable: unused-function
--#endregion

local h = require("color_helper")

local M = {}

---@param color string[]|string hex string list
---@param msg string|nil
function M.dump_console(color, msg)
	local DOT = " "
	if msg then
		io.write(msg)
	end
	local function dump(hex)
		local r, g, b = h.hex_to_rgb(hex)
		io.write(string.format("\27[38;2;%d;%d;%dm%s", r, g, b, DOT))
	end
	if type(color) == "string" then
		dump(color)
	else
		for _, color_item in ipairs(color) do
			dump(color_item)
		end
	end
	io.write("\27[0m\n")
end

---@param colors string[]|string hex string list
---@param msg string|nil
function M.dump_mako(colors, msg)
	local DOT = " "
	local formatted = {}
	if type(colors) == "string" then
		colors = { colors }
	end
	for _, hex in ipairs(colors) do
		local r, g, b = h.hex_to_rgb(hex)
		table.insert(formatted, string.format(
			'<span foreground="#%02x%02x%02x">%s</span>',
			r, g, b, DOT
		))
	end
	local markup = table.concat(formatted, "")
	local cmd = string.format(
		"notify-send '%s' '%s'",
		msg or "Color Preview",
		markup
	)
	os.execute(cmd)
end

---@param p tdf.ColorScheme
function M.invoke(p)
	local cag_config = require("center_config").load_tdf_config().color_auto_gen
	---@diagnostic disable-next-line: need-check-nil
	for _, gen_task in ipairs(cag_config.tasks) do
		GenerationTask.run(gen_task, p)
	end

	-- reload
	os.execute("hyprctl reload config-only")
	os.execute("pkill -SIGUSR2 waybar") -- TODO: 不知道为什么waybar的css引用嵌套多了重载没效果，需要手动
	os.execute("makoctl reload >/dev/null 2>&1")
	os.execute("fcitx5 -rd >/dev/null 2>&1")
	os.execute("pkill -SIGUSR1 kitty")
	os.execute("pkill -SIGUSR1 cava")
end

return M
