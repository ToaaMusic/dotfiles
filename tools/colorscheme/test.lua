#!/usr/bin/env lua

local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local tdf_dir = os.getenv("TOAAM_DOTFILES")
local deps = {
	script_dir .. "src/?.lua;",
	script_dir .. "tests/?.lua;",
	tdf_dir .. "/tools/shared/?.lua;",
}
for _, dep in ipairs(deps) do
	package.path = dep .. package.path
end

if arg[1] then
	local test_task_list = {}
	for i, test_mod in ipairs(arg) do
		local succes, run = pcall(require, test_mod .. "_test")
		if succes then
			table.remove(arg, i)
			table.insert(test_task_list, run)
		end
	end
	for _, task in ipairs(test_task_list) do
		task()
	end
else
	print("No test selected")
end
