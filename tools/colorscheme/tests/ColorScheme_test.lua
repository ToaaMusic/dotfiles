local new_Scheme = require("ColorScheme")
local write = require("write")
local ppm = require("ppm")
local sample = require("sample")

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

	local img = ppm.from_file(tdf_dir .. "/tools/colorscheme/test.ppm")
	---@diagnostic disable-next-line: param-type-mismatch
	local doms = sample.top_colors(img)
	local scheme = new_Scheme(doms)

	write.dump_console(doms, "dominants: ")
	write.dump_console(scheme.accent, "brand: ")
	write.dump_console(scheme.ansi_normal, "ansi_normal: ")
	write.dump_console(scheme.accents, "accents: ")
	write.dump_console(scheme.candidates, "candidates: ")
end
