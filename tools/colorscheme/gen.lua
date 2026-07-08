-- gen.lua
-- The entry of color generator

local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local tdf_dir = os.getenv("TOAAM_DOTFILES")
for _, dep in ipairs({
	script_dir .. "src/?.lua;",
	tdf_dir .. "/tools/shared/?.lua;",
}) do
	package.path = dep .. package.path
end

local logger = require("logger").get_logger()
local ppm = require("ppm")
local sample = require("sample")
local write = require("write")
local new_Scheme = require("ColorScheme")

-- 1. Load img data from stdin
local img, err = ppm.from_stdin()
if not img then
	logger:error(err or "")
	return
end

img:seed_rng()

-- 2. Sample dominant colors
local dominants = sample.top_colors(img, {
	-- sample.center_region(img),
})

if #dominants < 4 then
	logger:error("Not enough colors sampled from image")
end

-- 3. Generate Scheme
local scheme = new_Scheme(dominants)

--#region log

---[[
write.dump_mako(scheme.accents, "accents")
write.dump_mako(scheme.ansi_normal, "ansi_normal")
write.dump_mako(scheme.ansi_bright, "ansi_bright")
--]]

--#endregion

-- 4. Output
write.invoke(scheme)
