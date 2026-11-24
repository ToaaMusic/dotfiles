local ppm = require("ppm")
local sample = require("sample")
local write = require("write")

return function()
	local wall = os.getenv("TOAAM_DOTFILES") .. "/.cache/wall_cache.png"
	local p = ppm.from_any(wall)

	if not p then error("can't parse wallpaper" .. wall) end

	local tops = sample.top_colors(p)
	write.dump_console(tops)
end
