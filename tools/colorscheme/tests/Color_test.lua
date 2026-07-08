---@diagnostic disable: unused-local, missing-fields

local new_Color = require("Color")

return function()
	---@param color Color
	local function dump(color)
		local DOT = " "
		local content = string.format("\27[38;2;%d;%d;%dm%s", color.r, color.g, color.b, DOT)
		print(content .. "\27[0m")
	end

	local color = new_Color({ r = 200, g = 200, b = 0, })
	local black = new_Color()

	print(getmetatable(color))
	print("hex: ", color)
	print("hue: ", color:get_hue())
	print("distance to black: ", color:distance(black))
	print("contrast to black: ", color:contrast(black))
	print("mix with black: ", color:mix(black))
	dump(color)
end
