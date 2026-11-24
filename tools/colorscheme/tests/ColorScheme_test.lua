---@diagnostic disable: unused-local
local new_Scheme = require("ColorScheme")
local write = require("write")
local ppm = require("ppm")
local sample = require("sample")
local h = require("color_helper")

local tdf_dir = os.getenv("TOAAM_DOTFILES")

return function()
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
	write.dump_console(scheme.brand, "brand: ")
	write.dump_console(scheme.ansi16, "ansi16: ")
	write.dump_console(scheme.accents, "accents: ")
	write.dump_console(scheme.candidates, string.format("candidates (%d): ", #scheme.candidates))
	--]]

	local brand = scheme.brand
	write.dump_console(h.gradient(brand, h.black, 6))

	print(require("write").serialize_gtk_css(scheme))
end
