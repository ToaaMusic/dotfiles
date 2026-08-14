-- write.lua
-- write tdf.ColorScheme to config files

local h = require("color_helper")

local M = {}

--#region declarations

---@class FlatSerializeOpts
---@field kv_sep? string        key-value separator, e.g. "=", ":", " "
---@field k_sep? string|"-"|"_" separator for key path, default "-"
---@field terminator? string    line terminator, e.g. ";", "," or ""
---@field prefix? string        prefix for each line, e.g. "@define-color "
---@field indent? number        indentation level, default 0
---@field indent_width? string  indentation string, default "  "
---@field v_quote? string       wrap values with this quote char
---@field f_sep? string         the separator of lua field itself
---@field format? string        default "16#rgb"

--[[
A generation task. The `type` decides the generation function to use, or you can use `func` to specify your own.

`path` is the target file path. It's required.

A type name is one of the build-in functions: "flat", "lua", "gtk_css", or a custom one which is the name of a template module under `tpls/`.

`header` and `footer` are optional strings that will be written before and after the generated content.

when `type` is "flat", the scheme table will be serialized to flat key-value pairs with `flatOpts` options.

examples:

```lua
-- use build-in generation function like "gtk_css"
local task = {
  path = "~/.config/waybar/colors.g.css",
  type = "gtk_css",
}

-- use custom function
local task_custom = {
  path = "~/.config/foo/colors.g.txt",
  func = function(scheme)
    return "bg = " .. scheme.bg.common
  end
}

-- or create a template module under `tpls/` directory and use its name:
local task_tpl = {
  path = "~/.config/foo/colors.g.txt",
  type = "my_template",
}
```

the template file exports a function that takes a tdf.ColorScheme and returns the file content, which is the same as `func` field:

```lua
-- tpls/my_template.lua

---@param p tdf.ColorScheme
---@return string
return function(scheme)
  return "bg = " .. scheme.bg.common
end
```

usage of flat type:

```lua
local task_flat = {
  path = "~/.config/foo/colors.g.txt",
  type = "flat",
  flatOpts = {
    kv_sep = " = ",
    terminator = ";",
    prefix = "pre",
    indent = 2,
    indent_width = " ",
    v_quote = "\"",
		f_sep = "_",
  },
}
```

it will serialize the scheme table to lines like:

```lua
local scheme = {
  bg = {
  	common = "#24273a",
  },
  fg = {
  	common = "#cad3f5",
  },
  accents = ["#f5a97f", "#eed49f"]
  field_with_underline = "#cad3f5",
}
```

```txt
  pre bg-common = "#24273a";
  pre fg-common = "#cad3f5";
  pre accents1 = "#f5a97f";
  pre accents2 = "#eed49f";
  pre field-with-underline = "#cad3f5";
```

]]
---@class GenerationTask
---@field path string The target path
---@field type? string|"flat"|"lua"|"gtk_css" The type of file to generate, which decides the build-in generation function to use
---@field flatOpts? FlatSerializeOpts Flat serialize options, only used when type is "flat"
---@field func? fun(p:tdf.ColorScheme):string Your custom function to generate
---@field header? string The header content of the file to be generated
---@field footer? string The footer content of the file to be generated
local GenerationTask = {}
---@package
GenerationTask.__index = GenerationTask

--#endregion

---helper: check if a table is list
---@param tbl table
---@return boolean
local function is_list(tbl)
	if next(tbl) == nil then return false end
	local max = 0
	for k, v in pairs(tbl) do
		if type(k) ~= "number" or k <= 0 or v == nil then return false end
		if k > max then max = k end
	end
	if max == 0 then return false end
	for i = 1, max do
		if tbl[i] == nil then return false end
	end
	return true
end

---Serialize table to flat key-value pairs, only string values are kept.
---@param tbl table
---@param opts FlatSerializeOpts|nil
---@param path_prefix string|nil  accumulated path for nested tables, internal use
---@return string
local function serialize_flat(tbl, opts, path_prefix)
	opts = opts or {}
	local kv_sep = opts.kv_sep or " "
	local term = opts.terminator or ""
	local prefix = opts.prefix or ""
	local indent = opts.indent or 0
	local indent_w = opts.indent_width or "  "
	local vquote = opts.v_quote
	path_prefix = path_prefix or ""
	local k_sep = opts.k_sep or "-"
	local v_format = opts.format

	local function indent_str(level)
		return string.rep(indent_w, level)
	end

	---@diagnostic disable: unused-function, unused-local
	---@param template string
	local function parse_color_template(template, r, g, b, alpha)
		local base
		local processed_template = template

		local base_prefix = template:match("^(%d+)#")
		if base_prefix then
			base = tonumber(base_prefix) or 10
			processed_template = template:sub(#base_prefix + 2) -- remove "#"
		end

		---@param num number 0~255
		local function to_base(num)
			if base == 10 then return tostring(num) end
			local digits = "0123456789abcdefghijklmnopqrstuvwxyz"
			local result = ""
			local n = num
			repeat
				local remainder = n % base
				result = digits:sub(remainder + 1, remainder + 1) .. result
				n = math.floor(n / base)
			until n == 0
			return result
		end

		local replacements = {
			["%%r"] = to_base(r),
			["%%g"] = to_base(g),
			["%%b"] = to_base(b),
			["%%a"] = alpha and tostring(alpha) or "1",
			["%%%%"] = "%",
		}

		local result = processed_template
		for pattern, value in pairs(replacements) do
			result = result:gsub(pattern, value)
		end

		return result
	end

	local function fmt_val(v)
		if v_format then
			local r, g, b = h.hex_to_rgb(v)
			if r and g and b then
				v = parse_color_template(v_format, r, g, b)
			end
		end
		if vquote then
			return vquote .. v .. vquote
		end
		return v
	end

	local f_sep = opts.f_sep
	local function fmt_key(key)
		if f_sep then
			key = key:gsub("_", f_sep)
		end
		return key
	end

	local lines = {}
	for k, v in pairs(tbl) do
		local fmt_k = fmt_key(k)
		if type(v) == "table" and not is_list(v) then
			local sub_path = path_prefix ~= "" and (path_prefix .. k_sep .. fmt_k) or fmt_k
			lines[#lines + 1] = serialize_flat(v, opts, sub_path)
		elseif type(v) == "table" then
			for i = 1, #v do
				if type(v[i]) == "string" then
					local key = (path_prefix ~= "" and path_prefix or fmt_k) .. i
					lines[#lines + 1] = string.format("%s%s%s%s%s",
						indent_str(indent), prefix, key, kv_sep, fmt_val(v[i])) .. term
				end
			end
		else
			if type(v) == "string" then
				local key = path_prefix ~= "" and (path_prefix .. k_sep .. fmt_k) or fmt_k
				lines[#lines + 1] = string.format("%s%s%s%s%s",
					indent_str(indent), prefix, key, kv_sep, fmt_val(v)) .. term
			end
		end
	end

	table.sort(lines)
	return table.concat(lines, "\n")
end

---@param tbl table
---@return string
local function serialize_gtk_css(tbl)
	return serialize_flat(tbl, {
		terminator = ";",
		prefix = "@define-color ",
	})
end

---Serialize table to lua code string.
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
			if is_list(v) then
				-- Array-style table: { "a", "b", "c" }
				local items = {}
				for i = 1, #v do
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

---@package
---@param path string
---@param type string
---@param flatOpts FlatSerializeOpts|nil
---@param func fun(p:tdf.ColorScheme)|nil
---@param header string|nil
---@param footer string|nil
---@overload fun(tbl: table): GenerationTask
function GenerationTask.new(path, type, flatOpts, func, header, footer)
	if type(path) == "table" then
		return setmetatable(path, GenerationTask)
	end
	---@type GenerationTask
	local obj = {
		path = path,
		type = type,
		flatOpts = flatOpts,
		func = func,
		header = header,
		footer = footer
	}
	return setmetatable(obj, GenerationTask)
end

---@param self GenerationTask
---@param scheme tdf.ColorScheme
function GenerationTask:run(scheme)
	local path = self.path
	local func = self.func
	local header = self.header or ""
	local footer = self.footer or ""
	local t_type = self.type
	os.execute("mkdir -p " .. path:match("(.*/)"))
	local f = assert(io.open(path, "w"))
	local content
	if func ~= nil then
		content = func(scheme)
	elseif t_type == "lua" then
		content = "return " .. serialize_lua(scheme)
	elseif t_type == "gtk_css" then
		content = serialize_gtk_css(scheme)
	elseif t_type == "flat" then
		content = serialize_flat(scheme, self.flatOpts)
	elseif t_type ~= nil then
		local tpl = require("tpls." .. t_type)
		content = tpl(scheme)
	else
		content = ""
	end
	f:write(header .. content .. footer)
	f:close()
	if t_type == "lua" then
		os.execute("stylua " .. path .. " 2>/dev/null")
	end
end

--#region exports

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
	local cag_config = require("Config").load_tdf_config().color_auto_gen
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

M.serialize_lua = serialize_lua
M.serialize_flat = serialize_flat
M.serialize_gtk_css = serialize_gtk_css
M.GenerationTask = GenerationTask

return M

--#endregion
