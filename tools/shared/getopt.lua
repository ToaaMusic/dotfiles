--[[
# getopt.lua - Lua implementation inspired by util-linux getopt(1)

## usage

```lua
local opts, optind, err = getopt(arg, "ab:c::", {
  {"help",    "no_argument"},
  {"output",  "required_argument"},
  {"verbose", "optional_argument"},
  {"file",    "required_argument", "f"}, -- bind a short option
}, { alternative = false })
```

## params

* `args` : argument table (typically `arg`)
* `optstring` : short option string
  - `"a"`   → no argument
  - `"b:"`  → required argument
  - `"c::"` → optional argument
* `longopts` : long option definition table (can be nil)
  format: `{ "name", "no_argument"|"required_argument"|"optional_argument" [, short] }`
* `options` : optional config table
  - `alternative = true/false`   → corresponds to util-linux's `-a`
  - `posixly_correct = true`     → stop at first non-option (default: true)

## returns

* `opts`   : `{ short = {...}, long = {...}, order = {...} }`
* `index`  : index of the first non-option argument
* `err`    : error message (nil on success)
]]
---@param args string[]
---@param optstring string
---@param longopts table[]|nil
---@param options getoptOpts|nil
---@return getoptResult opts
---@return integer index
---@return string|nil err
local function getopt(args, optstring, longopts, options)
	local NO_ARGUMENT       = "no_argument"
	local REQUIRED_ARGUMENT = "required_argument"
	local OPTIONAL_ARGUMENT = "optional_argument"
	options                 = options or {}
	local alternative       = options.alternative or false
	local posixly_correct   = options.posixly_correct ~= false -- 默认 true

	local opts              = {
		short = {}, -- 短选项结果：['a'] = true / value
		long  = {}, -- 长选项结果：['help'] = true / value
		order = {}, -- 按出现顺序记录的选项列表（便于调试）
	}

	-------------------------------------------------
	-- 1. 解析短选项规则
	-------------------------------------------------
	local short_rules       = {} -- char -> 0/1/2 (0无参,1必选,2可选)
	do
		local i = 1
		while i <= #optstring do
			local c = optstring:sub(i, i)
			if c:match("[%a%d%?]") then
				local need = 0
				if optstring:sub(i + 1, i + 1) == ":" then
					need = 1
					i = i + 1
					if optstring:sub(i + 1, i + 1) == ":" then
						need = 2
						i = i + 1
					end
				end
				short_rules[c] = need
			end
			i = i + 1
		end
	end

	-------------------------------------------------
	-- 2. 解析长选项规则
	-------------------------------------------------
	local long_rules = {} -- name -> { need = 0/1/2, short = char|nil }
	if longopts then
		for _, item in ipairs(longopts) do
			local name, argtype, short = item[1], item[2], item[3]
			local need = 0
			if argtype == REQUIRED_ARGUMENT then
				need = 1
			elseif argtype == OPTIONAL_ARGUMENT then
				need = 2
			end
			long_rules[name] = { need = need, short = short }
			-- 如果同时绑定了短选项，也登记到 short_rules
			if short and not short_rules[short] then
				short_rules[short] = need
			end
		end
	end

	-------------------------------------------------
	-- 辅助：查找最长匹配的长选项（支持前缀歧义检测）
	-------------------------------------------------
	local function match_long(name)
		local exact, candidates = nil, {}
		for k, v in pairs(long_rules) do
			if k == name then
				exact = k
			elseif k:sub(1, #name) == name then
				candidates[#candidates + 1] = k
			end
		end
		if exact then return exact end
		if #candidates == 1 then return candidates[1] end
		if #candidates > 1 then
			return nil, "option '--" .. name .. "' is ambiguous; possibilities: '--" ..
					table.concat(candidates, "' '--") .. "'"
		end
		return nil, "unrecognized option '--" .. name .. "'"
	end

	-------------------------------------------------
	-- 3. 主解析循环
	-------------------------------------------------
	local i = 1
	local err = nil

	while i <= #args do
		local a = args[i]

		-- 非选项，停止（posixly_correct 模式）
		if a:sub(1, 1) ~= "-" or a == "-" then
			if posixly_correct then break end
			-- 非 posix 模式可以继续，但这里保持简单，直接 break
			break
		end

		-- 单独的 "--" 结束选项解析
		if a == "--" then
			i = i + 1
			break
		end

		-------------------------------------------------
		-- 长选项处理
		-------------------------------------------------
		if a:sub(1, 2) == "--" or (alternative and a:sub(1, 1) == "-" and #a > 2) then
			local is_long = a:sub(1, 2) == "--"
			local body = is_long and a:sub(3) or a:sub(2)

			local name, value
			local eq = body:find("=", 1, true)
			if eq then
				name  = body:sub(1, eq - 1)
				value = body:sub(eq + 1)
			else
				name = body
			end

			local matched, errmsg = match_long(name)
			if not matched then
				err = errmsg
				break
			end

			local rule = long_rules[matched]
			local need = rule.need

			if need == 0 then
				if value ~= nil then
					err = "option '--" .. matched .. "' doesn't allow an argument"
					break
				end
				opts.long[matched] = true
				if rule.short then opts.short[rule.short] = true end
				opts.order[#opts.order + 1] = { type = "long", name = matched, value = true }
			elseif need == 1 then
				if value == nil then
					i = i + 1
					if i > #args then
						err = "option '--" .. matched .. "' requires an argument"
						break
					end
					value = args[i]
				end
				opts.long[matched] = value
				if rule.short then opts.short[rule.short] = value end
				opts.order[#opts.order + 1] = { type = "long", name = matched, value = value }
			else -- optional
				if value == nil and i < #args and args[i + 1]:sub(1, 1) ~= "-" then
					i = i + 1
					value = args[i]
				end
				opts.long[matched] = value ~= nil and value or true
				if rule.short then opts.short[rule.short] = opts.long[matched] end
				opts.order[#opts.order + 1] = { type = "long", name = matched, value = opts.long[matched] }
			end

			i = i + 1
			goto continue
		end

		-------------------------------------------------
		-- 短选项处理（支持 -abc 连写）
		-------------------------------------------------
		local s = a:sub(2)
		local k = 1
		while k <= #s do
			local c = s:sub(k, k)
			local need = short_rules[c]

			if not need then
				err = "invalid option -- '" .. c .. "'"
				goto done
			end

			if need == 0 then
				opts.short[c] = true
				opts.order[#opts.order + 1] = { type = "short", name = c, value = true }
				k = k + 1
			elseif need == 1 then
				local value
				if k < #s then
					value = s:sub(k + 1)
					k = #s + 1
				else
					i = i + 1
					if i > #args then
						err = "option requires an argument -- '" .. c .. "'"
						goto done
					end
					value = args[i]
					k = #s + 1
				end
				opts.short[c] = value
				opts.order[#opts.order + 1] = { type = "short", name = c, value = value }
			else -- optional
				local value = true
				if k < #s then
					value = s:sub(k + 1)
					k = #s + 1
				elseif i < #args and args[i + 1]:sub(1, 1) ~= "-" then
					i = i + 1
					value = args[i]
					k = #s + 1
				else
					k = k + 1
				end
				opts.short[c] = value
				opts.order[#opts.order + 1] = { type = "short", name = c, value = value }
			end
		end

		i = i + 1
		::continue::
	end

	::done::
	return opts, i, err
end

---@class getoptOpts
---@field alternative boolean|nil
---@field posixly_correct boolean|nil

---@class getoptResult
---@field short table<string, boolean|string>
---@field long table<string, boolean|string>
---@field order table[]

return getopt
