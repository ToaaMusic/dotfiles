-- Color.lua
-- a wrapper of color_helper to a def Color struct

local h = require("color_helper")

---@class Color
---@field public hex string
---@field public r number
---@field public g number
---@field public b number
---@field public a number
---@field protected new fun(color:Color|nil):Color
---@field protected __tostring function
---@field protected __index Color
---@field protected __newindex function
---@field protected __eq function
---@field protected __add function
---@field protected __metatable any
local Color = {
	hex = "#000000",
	r = 0,
	g = 0,
	b = 0,
	a = 255,
	---@param t Color
	---@return string hex
	__tostring = function(t)
		return t.hex or nil
	end,
	---@param a Color
	---@param b Color
	---@return boolean
	__eq = function(a, b)
		return a.hex == b.hex
	end,
	---@diagnostic disable-next-line: unused-local
	__newindex = function(table, key, value)
		error("Cannot modify a Color instance directly.")
	end,
	__metatable = "Color class",
}
Color.__index = Color

---@param a Color
---@param b Color
---@return Color
Color.__add = function(a, b)
	---@diagnostic disable-next-line: missing-fields
	return Color.new({ hex = h.mix(a.hex, b.hex) })
end

---new a Color instance, a init is optional.
---@return Color
---@param color? Color a color inited
function Color.new(color)
	local init = color or {}
	if init.hex then
		init.r, init.g, init.b = h.hex_to_rgb(init.hex)
	elseif init.r and init.g and init.b then
		init.hex = h.rgb_to_hex(init.r, init.g, init.b)
	end
	return setmetatable(init, Color)
end

---Perceptual luma (0-255).
---@return number
function Color:get_luma()
	return h.get_luma(self.hex)
end

---Chroma (saturation in CIE Lch).
---@return number
function Color:get_chroma()
	return h.get_chroma(self.hex)
end

---Hue value (0-360).
---@return number|nil
function Color:get_hue()
	return h.get_hue(self.hex)
end

---Euclidean RGB distance between two colors.
---@return number
---@param color Color
function Color:distance(color)
	return h.get_distance(self.hex, color.hex)
end

---WCAG contrast ratio (>=1.0) between two colors.
---@return number
---@param color Color
function Color:contrast(color)
	return h.get_contrast(self.hex, color.hex)
end

---Mix with given color.
---@param color Color
function Color:mix(color)
	self.hex = h.mix(self.hex, color.hex)
	self.r, self.g, self.b = h.hex_to_rgb(self.hex)
	return self
end

return Color.new
