---@diagnostic disable: unused-local
local new_Scheme = require("ColorScheme")
local write = require("write")
local ppm = require("ppm")
local sample = require("sample")
local h = require("color_helper")
local s = require("strategy")

local tdf_dir = os.getenv("TOAAM_DOTFILES")

return function()
	-- local scheme = new_Scheme({
	-- 	"#c0cfd0",
	-- 	"#232625",
	-- 	"#2b2d2b",
	-- 	"#e78481",
	-- 	"#818284",
	-- 	"#878887",
	-- 	"#b3b3b2",
	-- 	"#f6f7f4",
	-- 	"#ed8c8c",
	-- 	"#109868",
	-- 	"#07989a",
	-- 	"#f2d17d",
	-- 	"#75b5af",
	-- 	"#b279a3"
	-- })

	local white = "#FFFFFF"
	local black = "#000000"

	local img, err = ppm.from_file(tdf_dir .. "/tools/colorscheme/test.ppm")
	if not img then
		error(err)
	end

	local doms = sample.top_colors(img, {
		samples = 12000,
		qbits = 5,
		topn = 16,
		-- min_luma = 13,
		-- max_luma = 242,
		oversample_factor = 10,
	})
	write.dump_console(doms, string.format("dominants (%d): ", #doms))

	---[[
	local scheme = new_Scheme(doms)
	write.dump_console(scheme.accent, "brand: ")
	write.dump_console(scheme.ansi_normal, "ansi_normal: ")
	write.dump_console(scheme.ansi_bright, "ansi_bright: ")
	write.dump_console(scheme.accents, "accents: ")
	write.dump_console(scheme.candidates, string.format("candidates (%d): ", #scheme.candidates))
	--]]

	local brand = scheme.accent
	write.dump_console(s.gradient(brand, black, 6))
end
