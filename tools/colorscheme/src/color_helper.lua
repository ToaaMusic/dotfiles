-- color_helper.lua
-- helpers for color, with no dependencies

local M = {}

-- [[ Internal ]]

---sRGB (0-255) to linearRGB (0-1)
---@param value number
---@return number
local function srgb_to_linear(value)
	value = value / 255
	return value <= 0.04045 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4 -- gamma
end

---Clamp to 0-255
---@param x number
---@return number
local function clamp_srgb(x)
	return math.max(0, math.min(255, x))
end

---Clamp to 0-1
---@param x number
---@return number
local function clamp_linear(x)
	return math.max(0, math.min(1, x))
end

-- [[ Public ]]

---Clamp value within [lo,hi].
---@param v number
---@param lo number
---@param hi number
---@return number v clamped
function M.clamp(v, lo, hi)
	if v < lo then
		return lo
	end
	if v > hi then
		return hi
	end
	return v
end

-- [[ Conversion ]]

---Convert hex string to RGB.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hex_to_rgb(hex)
	hex = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

---Convert RGB components to hex string.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return string hex #000000-#FFFFFF
function M.rgb_to_hex(r, g, b)
	return string.format(
		"#%02x%02x%02x",
		math.floor(clamp_srgb(r)),
		math.floor(clamp_srgb(g)),
		math.floor(clamp_srgb(b))
	)
end

---Convert RGB to HSV.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number v Value: 0-1
function M.rgb_to_hsv(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local maxc, minc = math.max(r, g, b), math.min(r, g, b)
	local delta = maxc - minc

	local h = 0
	if delta ~= 0 then
		if maxc == r then
			h = ((g - b) / delta) % 6
		elseif maxc == g then
			h = ((b - r) / delta) + 2
		else
			h = ((r - g) / delta) + 4
		end
		h = h * 60
	end

	local s = maxc == 0 and 0 or delta / maxc
	local v = maxc
	return h, s, v
end

---Convert HSV to RGB.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param v number Value: 0-1
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hsv_to_rgb(h, s, v)
	h = (h or 0) % 360
	s = clamp_linear(s or 0)
	v = clamp_linear(v or 0)

	local c = v * s
	local x = c * (1 - math.abs(((h / 60) % 2) - 1))
	local m = v - c

	local r1, g1, b1
	if h < 60 then
		r1, g1, b1 = c, x, 0
	elseif h < 120 then
		r1, g1, b1 = x, c, 0
	elseif h < 180 then
		r1, g1, b1 = 0, c, x
	elseif h < 240 then
		r1, g1, b1 = 0, x, c
	elseif h < 300 then
		r1, g1, b1 = x, 0, c
	else
		r1, g1, b1 = c, 0, x
	end

	return (r1 + m) * 255, (g1 + m) * 255, (b1 + m) * 255
end

---Convert hex string to HSV components.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number v Value: 0-1
function M.hex_to_hsv(hex)
	return M.rgb_to_hsv(M.hex_to_rgb(hex))
end

---Convert HSV components to hex string.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param v number Value: 0-1
---@return string hex #000000-#FFFFFF
function M.hsv_to_hex(h, s, v)
	return M.rgb_to_hex(M.hsv_to_rgb(h, s, v))
end

---Convert RGB to HSL.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number l Lightness: 0-1
function M.rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local maxc, minc = math.max(r, g, b), math.min(r, g, b)
	local delta = maxc - minc

	local h = 0
	if delta ~= 0 then
		if maxc == r then
			h = ((g - b) / delta) % 6
		elseif maxc == g then
			h = ((b - r) / delta) + 2
		else
			h = ((r - g) / delta) + 4
		end
		h = h * 60
	end
	local l = (maxc + minc) / 2
	local s = delta == 0 and 0 or delta / (1 - math.abs(2 * l - 1))
	return h, s, l
end

---Convert HSL to RGB.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param l number Lightness: 0-1
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hsl_to_rgb(h, s, l)
	h = (h or 0) % 360
	s = clamp_linear(s or 0)
	l = clamp_linear(l or 0)
	local c = (1 - math.abs(2 * l - 1)) * s
	local x = c * (1 - math.abs(((h / 60) % 2) - 1))
	local m = l - c / 2

	local r1, g1, b1
	if h < 60 then
		r1, g1, b1 = c, x, 0
	elseif h < 120 then
		r1, g1, b1 = x, c, 0
	elseif h < 180 then
		r1, g1, b1 = 0, c, x
	elseif h < 240 then
		r1, g1, b1 = 0, x, c
	elseif h < 300 then
		r1, g1, b1 = x, 0, c
	else
		r1, g1, b1 = c, 0, x
	end
	return (r1 + m) * 255, (g1 + m) * 255, (b1 + m) * 255
end

---Convert hex string to HSL components.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number l Lightness: 0-1
function M.hex_to_hsl(hex)
	return M.rgb_to_hsl(M.hex_to_rgb(hex))
end

---Convert HSL components to hex string.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param l number Lightness: 0-1
---@return string hex #000000-#FFFFFF
function M.hsl_to_hex(h, s, l)
	return M.rgb_to_hex(M.hsl_to_rgb(h, s, l))
end

-- [[ Get Properties ]]

-- https://www.w3.org/TR/AERT/#color-contrast

---Perceptual luma from RGB values.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number luma 0-255
function M.rgb_get_luma(r, g, b)
	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

---Perceptual luma from hex string.
---@param hex string #000000-#FFFFFF
---@return number luma 0-255
function M.get_luma(hex)
	return M.rgb_get_luma(M.hex_to_rgb(hex))
end

---Relative luminance for WCAG (0.0-1.0).
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number luminance 0.0-1.0
function M.get_luminance(hex)
	local r, g, b = M.hex_to_rgb(hex)
	return 0.2126 * srgb_to_linear(r) + 0.7152 * srgb_to_linear(g) + 0.0722 * srgb_to_linear(b)
end

---Hue in degrees (0-360) or nil.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number|nil hue 0-360
function M.get_hue(hex)
	local r, g, b = M.hex_to_rgb(hex)
	r, g, b = r / 255, g / 255, b / 255
	local maxc, minc = math.max(r, g, b), math.min(r, g, b)
	local delta = maxc - minc
	if delta == 0 then
		return nil
	end

	local hue
	if maxc == r then
		hue = ((g - b) / delta) % 6
	elseif maxc == g then
		hue = ((b - r) / delta) + 2
	else
		hue = ((r - g) / delta) + 4
	end
	return hue * 60
end

---Color chroma/saturation.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number chroma 0-255
function M.get_chroma(hex)
	local r, g, b = M.hex_to_rgb(hex)
	return math.max(r, g, b) - math.min(r, g, b)
end

-- [[ Comparison ]]

---Euclidean RGB distance.
---@param hex1 string
---@param hex2 string
---@return number distance 0-441.67
function M.get_distance(hex1, hex2)
	local r1, g1, b1 = M.hex_to_rgb(hex1)
	local r2, g2, b2 = M.hex_to_rgb(hex2)
	return math.sqrt((r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2)
end

---Wrapped hue distance (0-180).
---@param hex1 string
---@param hex2 string
---@return number distance 0-180
function M.get_hue_distance(hex1, hex2)
	local h1, h2 = M.get_hue(hex1), M.get_hue(hex2)
	if not h1 or not h2 then
		return 0
	end
	local diff = math.abs(h1 - h2)
	return math.min(diff, 360 - diff)
end

---WCAG contrast ratio.
---@param hex1 string
---@param hex2 string
---@return number ratio >=1.0
function M.get_contrast(hex1, hex2)
	local l1 = M.get_luminance(hex1)
	local l2 = M.get_luminance(hex2)
	return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05)
end

-- [[ Manipulation ]]

---Mix two colors (ratio 0.0-1.0).
---@param hex1 string
---@param hex2 string
---@param ratio number|nil 0 = all hex1, 1 = all hex2 (default: 0.5)
---@return string hex #000000-#FFFFFF
function M.mix(hex1, hex2, ratio)
	ratio = ratio or 0.5
	local r1, g1, b1 = M.hex_to_rgb(hex1)
	local r2, g2, b2 = M.hex_to_rgb(hex2)
	return M.rgb_to_hex(r1 + (r2 - r1) * ratio + 0.5, g1 + (g2 - g1) * ratio + 0.5, b1 + (b2 - b1) * ratio + 0.5)
end

---chage hue of a hex
---@param hex string #000000-#FFFFFF
---@param hue_to_chage number 0-360
---@return string hex #000000-#FFFFFF
function M.change_hue(hex, hue_to_chage)
	local _, s, l = M.hex_to_hsl(hex)
	return M.hsl_to_hex(hue_to_chage, s, l)
end

---Rotate a color hue in HSV space.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@param degrees number Degrees (+360 to -360) to rotate hue (default: 0).
---@return string hex hue-rotated hex color (#000000-#FFFFFF).
function M.rotate_hue(hex, degrees)
	local h, s, v = M.hex_to_hsv(hex)
	h = (h + (degrees or 0)) % 360
	return M.hsv_to_hex(h, s, v)
end

---Quantisized color key
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@param qbits number 1-8
---@return number key 0..2^(3*qbits)-1
function M.quantize(r, g, b, qbits)
	local shift = 8 - qbits
	local rq = r >> shift
	local gq = g >> shift
	local bq = b >> shift
	return (rq << (2 * qbits)) | (gq << qbits) | bq
end

---Reproduce RGB from a quantized key.
---@param key number
---@param qbits number 1-8
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.dequantize(key, qbits)
	local mask = (1 << qbits) - 1
	local bq = key & mask
	local gq = (key >> qbits) & mask
	local rq = (key >> (2 * qbits)) & mask

	local shift = 8 - qbits
	local half = (shift > 0) and (1 << (shift - 1)) or 0
	local r = rq * (1 << shift) + half
	local g = gq * (1 << shift) + half
	local b = bq * (1 << shift) + half
	return M.clamp(r, 0, 255), M.clamp(g, 0, 255), M.clamp(b, 0, 255)
end

return M
