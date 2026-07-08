#!/usr/bin/env lua

local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local tdf_dir = os.getenv("TOAAM_DOTFILES")
local deps = {
	script_dir .. "src/?.lua;",
	script_dir .. "tests/?.lua;",
	tdf_dir .. "/tools/shared/?.lua;",
	tdf_dir .. "/scripts/?.lua;",
}
for _, dep in ipairs(deps) do
	package.path = dep .. package.path
end

if arg[1] then
	for _, test_mod in ipairs(arg) do
		local run = require(test_mod .. "_test")
		run()
	end
else
	print("No test selected")
end
