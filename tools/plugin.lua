--[[
    A LuaLS plugin that implements a custom annotation:

        ---@class Foo
        ---@field name string
        ---@field friend Bar
        ---@allnullable Foo

    Whenever a line `---@allnullable Foo` is seen, the plugin generates a new
    class `FooAllNullable` whose fields are all optional (nullable):

        ---@class FooAllNullable
        ---@field name? string
        ---@field friend? BarAllNullable

    Rules:
      * The `---@allnullable Foo` marker may appear anywhere in the file, not
        just right after the class; blank lines in between are fine.
      * A `---@field` line belongs to the nearest preceding `---@class`.
      * If a field's type references another class defined in THIS file
        (e.g. `Bar`), the field type is rewritten to `BarAllNullable`, and the
        `BarAllNullable` class is generated automatically too (recursively,
        but with a guard against cycles / duplicates).
      * Types that are not local classes (e.g. `string`, `number`, imported
        classes) are left unchanged, only the field name gets the `?` marker.
]]

local SUFFIX = "AllNullable"

---@class Line
---@field text string
---@field pos integer

---@class FieldLine
---@field name string
---@field optional boolean
---@field extend string

---@return Line[]
local function lines(text)
	local result = {}
	local pos = 1
	for line in text:gmatch('([^\n]*)') do
		result[#result + 1] = { text = line, pos = pos }
		pos = pos + #line + 1 -- +1 for the newline
	end
	return result
end

---@return FieldLine|nil
local function parseFieldLine(lineText)
	local rest = lineText:match('^%-%-%-@field%s+(.+)$')
	if not rest then
		return nil
	end
	local vis = rest:match('^([%a]+)%s+')
	if vis == 'public' or vis == 'protected'
			or vis == 'private' or vis == 'package' then
		rest = rest:sub(#vis + 1):gsub('^%s+', '')
	end
	local name, optional, extend = rest:match('^([%w%d_%.%[%]]*)%s*(%??)%s*=?%s*(.+)$')
	if not name or name == '' then
		return nil
	end
	return {
		name = name,
		optional = optional == '?',
		extend = extend:gsub('%s*$', ''),
	}
end

local function parseClassLine(l)
	return l:match('^%-%-%-@class%s+([_%w%.]+)')
end

local function parseMarkerLine(l)
	return l:match('^%-%-%-@allnullable%s+([_%w%.]+)')
end

--- Return the set of local class names referenced inside a type expression,
--- with each class name's occurrences replaced by `<name>AllNullable`.
--- A class name may be dotted (`tdf.ColorScheme`). Longer names are matched
--- before shorter ones to avoid replacing a substring. Uses a placeholder
--- two-pass replace to be robust against `.` / partial-name overlaps.
--- Returns (rewrittenType, referencedClassNamesInOrder).
local function rewriteType(typ, localClasses)
	local names = {}
	for name in pairs(localClasses) do names[#names + 1] = name end
	table.sort(names, function(a, b) return #a > #b end)

	local referenced = {}
	local result = typ
	for _, name in ipairs(names) do
		-- literal match: escape every non-alphanumeric char (esp. the dot)
		local esc = name:gsub('([^%w_])', '%%%1')
		local used = false
		result = result:gsub(esc, function()
			used = true
			return '\0' .. name .. '\0' -- placeholder; 'name' has no \0
		end)
		if used then
			referenced[#referenced + 1] = name
		end
	end

	-- second pass: replace placeholders with the AllNullable name
	result = result:gsub('%z([^\0]*)%z', '%1' .. SUFFIX)

	return result, referenced
end

-- https://luals.github.io/wiki/plugins/#functions

---@class diff
---@field start integer # The number of bytes at the beginning of the replacement
---@field finish integer # The number of bytes at the end of the replacement
---@field text string  # What to replace

---@param _ string # The uri of file
---@param text string # The content of file
---@return nil|diff[]
function OnSetText(_, text)
	local ls = lines(text)

	-- 1. index all local class names + markers
	local localClasses = {}  -- set of class names defined in this file
	local markers = {}       -- ordered list of { name, lineIndex, indent }
	local classLineIndex = {} -- class name -> line index

	for i, ln in ipairs(ls) do
		local cls = parseClassLine(ln.text)
		if cls then
			localClasses[cls] = true
			classLineIndex[cls] = i
		else
			local marker = parseMarkerLine(ln.text)
			if marker then
				markers[#markers + 1] = {
					name = marker,
					lineIndex = i,
					indent = ln.text:match('^(%s*)') or '',
				}
			end
		end
	end

	-- 2. associate each @field with the nearest preceding @class
	local classFields = {} -- class name -> array of field descriptors
	local currentClass = nil
	for _, ln in ipairs(ls) do
		local cls = parseClassLine(ln.text)
		if cls then
			currentClass = cls
		elseif currentClass then
			local f = parseFieldLine(ln.text)
			if f then
				classFields[currentClass] = classFields[currentClass] or {}
				classFields[currentClass][#classFields[currentClass] + 1] = f
			end
		end
	end

	if #markers == 0 then
		return nil
	end

	-- 3. recursively compute the generated "name? type" lines, with
	--    cycle / duplicate guard. A class referenced by multiple markers is
	--    emitted only once (at the first marker that needs it).
	local computed = {} -- class name -> array of "name? type" strings
	local emitted = {} -- class name -> true once its block is written

	local function ensureClass(className)
		if not localClasses[className] then
			return
		end
		if computed[className] then
			return
		end
		computed[className] = true

		local lines_ = {}
		for _, f in ipairs(classFields[className] or {}) do
			local newExtend, referenced = rewriteType(f.extend, localClasses)
			for _, ref in ipairs(referenced) do
				if ref ~= className then
					ensureClass(ref)
				end
			end
			lines_[#lines_ + 1] = string.format('%s? %s', f.name, newExtend)
		end
		computed[className] = lines_
	end

	for _, m in ipairs(markers) do
		ensureClass(m.name)
	end

	-- 4. emit diffs: each marker yields one consolidated block containing
	--    itself plus every not-yet-emitted class in its reference closure.
	local diffs = {}

	local function renderClass(className, indent)
		local bodyLines = { string.format('---@class %s%s', className, SUFFIX) }
		for _, fl in ipairs(computed[className] or {}) do
			bodyLines[#bodyLines + 1] = '---@field ' .. fl
		end
		local out = {}
		for _, bl in ipairs(bodyLines) do
			out[#out + 1] = indent .. bl
		end
		return table.concat(out, '\n')
	end

	-- collect, per marker, the ordered closure of classes to emit
	for _, m in ipairs(markers) do
		local closure = {} -- ordered class names
		local seen = {}  -- local guard

		local function visit(className)
			if seen[className] then return end
			seen[className] = true
			-- visit referenced classes first (so the referenced class is
			-- defined before its referrer, if emitted in the same block)
			for _, f in ipairs(classFields[className] or {}) do
				local _, referenced = rewriteType(f.extend, localClasses)
				for _, ref in ipairs(referenced) do
					if ref ~= className then
						visit(ref)
					end
				end
			end
			closure[#closure + 1] = className
		end
		visit(m.name)

		local blocks = {}
		for _, className in ipairs(closure) do
			if not emitted[className] then
				emitted[className] = true
				blocks[#blocks + 1] = renderClass(className, m.indent)
			end
		end

		if #blocks > 0 then
			local insertAt = ls[m.lineIndex].pos + #ls[m.lineIndex].text + 1
			diffs[#diffs + 1] = {
				start  = insertAt,
				finish = insertAt - 1,
				text   = table.concat(blocks, '\n') .. '\n',
			}
		end
	end

	if #diffs == 0 then
		return nil
	end

	table.sort(diffs, function(a, b) return a.start < b.start end)
	return diffs
end
