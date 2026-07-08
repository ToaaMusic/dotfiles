local new_Scheme = require("ColorScheme")
local write = require("write")
local ppm = require("ppm")
local sample = require("sample")

return function()
	local scheme = new_Scheme({
		"#c0cfd0",
		"#232625",
		"#2b2d2b",
		"#e78481",
		"#818284",
		"#878887",
		"#b3b3b2",
		"#f6f7f4",
		"#ed8c8c",
		"#109868",
		"#07989a",
		"#f2d17d",
		"#75b5af",
		"#b279a3"
	})

	-- local scheme = new_Scheme(sample.top_colors(ppm.))

	write.dump_mako(scheme.ansi_normal)
end
