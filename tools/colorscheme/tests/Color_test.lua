---@diagnostic disable: unused-local, missing-fields

local new_Color = require("Color")
local write = require("write")

return function()
	local color = new_Color({ r = 225, g = 179, b = 203, })
	local black = new_Color()

	-- print(getmetatable(color))
	write.dump_console(color.hex)
	print("hex: ", color)
	print("hue: ", color:get_hue())
	-- print("distance to black: ", color:distance(black))
	-- print("contrast to black: ", color:contrast(black))
	-- print("mix with black: ", color:mix(black))
	write.dump_console(color:set_hue(180))
end
