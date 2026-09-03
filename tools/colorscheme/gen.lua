-- gen.lua
-- The entry of color generator

---@diagnostic disable: need-check-nil

local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
local tdf_dir = os.getenv("TOAAM_DOTFILES")
for _, dep in ipairs({
	script_dir .. "?.lua;",
	script_dir .. "src/?.lua;",
	tdf_dir .. "/tools/shared/?.lua;",
}) do
	package.path = dep .. package.path
end

--config
local config = require("Config").load_tdf_config()
local gen_config = config.color_auto_gen
if not gen_config.enable then return end

local getopt = require("getopt")
local logger = require("logger").get_logger()
local ppm = require("ppm")
local sample = require("sample")
local write = require("write")
local new_Scheme = require("ColorScheme")

-- arg

local opts, _, arg_err = getopt(arg, "hf:", nil, {
	alternative = false,
	posixly_correct = true,
})

if arg_err then
	print("Error:", arg_err)
	os.exit(1)
end

-- 1. Load img data from stdin
local img, err
if opts.short["f"] then
	img, err = ppm.from_file(opts.short["f"])
else
	img, err = ppm.from_stdin()
end

if not img then
	logger:error(err or "")
	return
end

img:seed_rng()

-- 2. Sample dominant colors
local dominants = sample.top_colors(img, {
	-- topn = 1000,
	-- qbits = 4,
	-- sample.center_region(img),
})

-- 3. Generate Scheme
local scheme = new_Scheme(dominants, gen_config)

-- 4. Output
write.invoke(scheme)

if gen_config.notify then
	os.execute([[
WALL=$("$TOAAM_DOTFILES/scripts/kv.sh" "$TOAAM_DOTFILES/.cache" wallpaper 2>/dev/null) &&
notify-send "Wallpaper Changed" "$(basename "$WALL")" -i "$WALL"
]])
end
