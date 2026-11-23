-- color_helper.lua
-- helpers for color, with no dependencies

-- vim:foldmethod=marker:foldmarker={{{,}}}

local M = {
	white = "#FFFFFF",
	black = "#000000",
	red = "#FF0000",
	green = "#00FF00",
	blue = "#0000FF",
	yellow = "#FFFF00",
	magenta = "#FF00FF",
	cyan = "#00FFFF",
}

-- Internal {{{

---sRGB (0-255) to linearRGB (0-1)
---@param value number
---@return number
local function srgb_to_linear(value)                                          -- {{{
	value = value / 255
	return value <= 0.04045 and value / 12.92 or ((value + 0.055) / 1.055) ^ 2.4 -- gamma
end
-- }}}

---Clamp to 0-255
---@param x number
---@return number
local function clamp_srgb(x) -- {{{
	return math.max(0, math.min(255, x))
end
-- }}}

---Clamp to 0-1
---@param x number
---@return number
local function clamp_linear(x) -- {{{
	return math.max(0, math.min(1, x))
end
-- }}}

local function cbrtf(x) return x >= 0 and x ^ (1 / 3) or -((-x) ^ (1 / 3)) end

-- }}}

-- Others {{{

---Clamp value within [lo,hi].
---@param v number
---@param lo number
---@param hi number
---@return number v clamped
function M.clamp(v, lo, hi) -- {{{
	if v < lo then
		return lo
	end
	if v > hi then
		return hi
	end
	return v
end

-- }}}

---filter identical colors
---@param colors string[] hex color list
---@return string[] colors filtered identical hex color list
function M.unique_colors(colors) -- {{{
	local out, seen = {}, {}
	for _, item in ipairs(colors) do
		local key = item:lower()
		if not seen[key] then
			seen[key] = true
			out[#out + 1] = item
		end
	end
	return out
end

-- }}}

-- }}}

-- Conversion {{{

---Convert hex string to RGB.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hex_to_rgb(hex) -- {{{
	hex = hex:gsub("#", "")
	return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

-- }}}

---Convert RGB components to hex string.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return string hex #000000-#FFFFFF
function M.rgb_to_hex(r, g, b) -- {{{
	return string.format(
		"#%02x%02x%02x",
		math.floor(clamp_srgb(r)),
		math.floor(clamp_srgb(g)),
		math.floor(clamp_srgb(b))
	)
end

-- }}}

---Convert RGB to HSV.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number v Value: 0-1
function M.rgb_to_hsv(r, g, b) -- {{{
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

-- }}}

---Convert HSV to RGB.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param v number Value: 0-1
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hsv_to_rgb(h, s, v) -- {{{
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

-- }}}

---Convert RGB to HSL.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number l Lightness: 0-1
function M.rgb_to_hsl(r, g, b) -- {{{
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

-- }}}

---Convert HSL to RGB.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param l number Lightness: 0-1
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.hsl_to_rgb(h, s, l) -- {{{
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

-- }}}

---Convert hex string to HSV components.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number v Value: 0-1
function M.hex_to_hsv(hex) -- {{{
	return M.rgb_to_hsv(M.hex_to_rgb(hex))
end

-- }}}

---Convert HSV components to hex string.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param v number Value: 0-1
---@return string hex #000000-#FFFFFF
function M.hsv_to_hex(h, s, v) -- {{{
	return M.rgb_to_hex(M.hsv_to_rgb(h, s, v))
end

-- }}}

---Convert hex string to HSL components.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number h Hue: 0-360
---@return number s Saturation: 0-1
---@return number l Lightness: 0-1
function M.hex_to_hsl(hex) -- {{{
	return M.rgb_to_hsl(M.hex_to_rgb(hex))
end

-- }}}

---Convert HSL components to hex string.
---@param h number Hue: 0-360
---@param s number Saturation: 0-1
---@param l number Lightness: 0-1
---@return string hex #000000-#FFFFFF
function M.hsl_to_hex(h, s, l) -- {{{
	return M.rgb_to_hex(M.hsl_to_rgb(h, s, l))
end

-- }}}
-- }}}

-- Get Properties {{{

-- https://www.w3.org/TR/AERT/#color-contrast

---Perceptual luma from RGB values.
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@return number luma 0-255
function M.rgb_get_luma(r, g, b) -- {{{
	return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

-- }}}

---Perceptual luma from hex string.
---@param hex string #000000-#FFFFFF
---@return number luma 0-255
function M.get_luma(hex) -- {{{
	return M.rgb_get_luma(M.hex_to_rgb(hex))
end

-- }}}

---Relative luminance for WCAG (0.0-1.0).
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number luminance 0.0-1.0
function M.get_luminance(hex) -- {{{
	local r, g, b = M.hex_to_rgb(hex)
	return 0.2126 * srgb_to_linear(r) + 0.7152 * srgb_to_linear(g) + 0.0722 * srgb_to_linear(b)
end

-- }}}

---Hue in degrees (0-360) or nil.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number|nil hue 0-360
function M.get_hue(hex) -- {{{
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

-- }}}

---Color chroma/saturation.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@return number chroma 0-255
function M.get_chroma(hex) -- {{{
	local r, g, b = M.hex_to_rgb(hex)
	return math.max(r, g, b) - math.min(r, g, b)
end

-- }}}
-- }}}

-- Comparison {{{

---Euclidean RGB distance.
---@param hex1 string
---@param hex2 string
---@return number distance 0-441.67
function M.get_distance(hex1, hex2) -- {{{
	local r1, g1, b1 = M.hex_to_rgb(hex1)
	local r2, g2, b2 = M.hex_to_rgb(hex2)
	return math.sqrt((r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2)
end

-- }}}

---Wrapped hue distance (0-180).
---@param hex1 string
---@param hex2 string
---@return number distance 0-180
function M.get_hue_distance(hex1, hex2) -- {{{
	local h1, h2 = M.get_hue(hex1), M.get_hue(hex2)
	if not h1 or not h2 then
		return 0
	end
	local diff = math.abs(h1 - h2)
	return math.min(diff, 360 - diff)
end

-- }}}

---WCAG contrast ratio.
---@param hex1 string
---@param hex2 string
---@return number ratio >=1.0
function M.get_contrast(hex1, hex2) -- {{{
	local l1 = M.get_luminance(hex1)
	local l2 = M.get_luminance(hex2)
	return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05)
end

-- }}}

---return true if the hex is dark (luminance < 0.5)
---@param hex string
---@return boolean is_dark
function M.is_dark(hex) -- {{{
	return M.get_luminance(hex) < 0.5

	-- return h.get_luma(hex) < 140

	-- local black, white = "#000000", "#ffffff"
	-- return h.get_contrast(black, bg_hex) <= h.get_contrast(white, bg_hex)
end

-- }}}

---return bg is dark ? "#ffffff" : "#000000"
---@param bg_hex string
---@return string color black/white
function M.best_text(bg_hex) -- {{{
	return M.is_dark(bg_hex) and M.white or M.black
end

-- }}}

-- }}}

-- Manipulation {{{

---Mix two colors (ratio 0.0-1.0).
---@param hex1 string
---@param hex2 string
---@param ratio number|nil 0 = all hex1, 1 = all hex2 (default: 0.5)
---@return string hex #000000-#FFFFFF
function M.mix(hex1, hex2, ratio) -- {{{
	ratio = ratio or 0.5
	local r1, g1, b1 = M.hex_to_rgb(hex1)
	local r2, g2, b2 = M.hex_to_rgb(hex2)
	return M.rgb_to_hex(r1 + (r2 - r1) * ratio + 0.5, g1 + (g2 - g1) * ratio + 0.5, b1 + (b2 - b1) * ratio + 0.5)
end

-- }}}

---Change lightness of a hex (HSL L)
---@param hex string #000000-#FFFFFF
---@param l_to_change number 0-1
---@return string hex #000000-#FFFFFF
function M.change_lightness(hex, l_to_change) -- {{{
	local h, s, _ = M.hex_to_hsl(hex)
	return M.hsl_to_hex(h, s, l_to_change)
end

-- }}}

---chage hue of a hex
---@param hex string #000000-#FFFFFF
---@param hue_to_chage number 0-360
---@return string hex #000000-#FFFFFF
function M.change_hue(hex, hue_to_chage) -- {{{
	local _, s, l = M.hex_to_hsl(hex)
	return M.hsl_to_hex(hue_to_chage, s, l)
end

-- }}}

---Rotate a color hue in HSV space.
---@param hex string A hex color in string (#000000-#FFFFFF).
---@param degrees number Degrees (+360 to -360) to rotate hue (default: 0).
---@return string hex hue-rotated hex color (#000000-#FFFFFF).
function M.rotate_hue(hex, degrees) -- {{{
	local h, s, v = M.hex_to_hsv(hex)
	h = (h + (degrees or 0)) % 360
	return M.hsv_to_hex(h, s, v)
end

-- }}}

---Quantisized color key
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@param qbits number 1-8
---@return number key 0..2^(3*qbits)-1
function M.quantize(r, g, b, qbits) -- {{{
	local shift = 8 - qbits
	local rq = r >> shift
	local gq = g >> shift
	local bq = b >> shift
	return (rq << (2 * qbits)) | (gq << qbits) | bq
end

-- }}}

---Reproduce RGB from a quantized key.
---@param key number
---@param qbits number 1-8
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
function M.dequantize(key, qbits) --{{{
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

-- }}}

--- Generate an array of color strings by interpolating between two hex colors
---@param color1 string First hex color
---@param color2 string Second hex color
---@param length number Number of colors to generate
---@return string[] result Array of hex color strings
function M.gradient(color1, color2, length) -- {{{
	local colors = {}

	for i = 1, length do
		local ratio = (i - 1) / (length - 1)
		colors[i] = M.mix(color1, color2, ratio)
	end

	return colors
end

-- }}}

--[[
**Ensure fg has enough contrast to bg.**

This function will try to lift fg by mixing towards the best text color until the contrast ratio is lifted to **min_ratio** or **times** reached.
]]
---@param fg string the color to be lifted
---@param bg string the background color used for contrast
---@param min_ratio number|nil the minimum contrast ratio to bg, default 2.8
---@param step number|nil step size, default 0.16
---@param times number|nil max iterations, default 12
---@return string color fg after lifting contrast
function M.ensure_contrast(fg, bg, min_ratio, step, times) -- {{{
	min_ratio = min_ratio or 2.8
	step = step or 0.16
	times = times or 12
	if M.get_contrast(fg, bg) >= min_ratio then
		return fg
	end

	local current, best = fg, M.best_text(bg)
	for _ = 1, times do
		current = M.mix(current, best, step)
		if M.get_contrast(current, bg) >= min_ratio then
			return current
		end
	end
	return current
end

-- }}}

---push if distinct in overall distance and hue.
---@param out string[] the list to push in
---@param hex string the color to push
---@param min_dist number|nil minimum distance, default 36
---@param min_hue_dist number|nil minimum hue distance, default 28
---@return boolean
function M.push_if_varied(out, hex, min_dist, min_hue_dist) -- {{{
	min_dist = min_dist or 36
	min_hue_dist = min_hue_dist or 28
	local hue = M.get_hue(hex)
	for _, existing in ipairs(out) do
		if M.get_distance(existing, hex) < min_dist then
			return false
		end
		if hue and M.get_hue(existing) and M.get_hue_distance(existing, hex) < min_hue_dist then
			return false
		end
	end
	out[#out + 1] = hex
	return true
end

-- }}}

---score a hex for role priority (sum of hue match, chroma, contrast to bg).
---@param hex string the color to be scored
---@param target_hue number the target hue
---@param bg string the background color to compute contrast
---@return number score
function M.score_role(hex, target_hue, bg) -- {{{
	local hue = M.get_hue(hex)

	-- hue match score
	local hue_score = 0
	if hue then
		local diff = math.abs(hue - target_hue)
		hue_score = (180 - math.min(diff, 360 - diff)) * 0.9
	end

	local chroma_score = M.get_chroma(hex) * 0.7
	local contrast_to_bg_score = math.min(M.get_contrast(hex, bg), 6) * 16
	return hue_score + chroma_score + contrast_to_bg_score
end

-- }}}

---pick highest scored color using score_role from candidates that isn't used.
---@param candidates string[] the list of candidates to rank.
---@param bg string the background color to compute contrast
---@param used table<string, boolean>
---@param target_hue number 0-360 the target hue
---@param fallback string fallback color
---@return string color best hex
function M.pick_role_color(candidates, target_hue, bg, used, fallback) -- {{{
	local best_hex, best_score
	for _, hex in ipairs(candidates) do
		if not used[hex] then
			local score = M.score_role(hex, target_hue, bg)
			if not best_score or score > best_score then
				best_hex, best_score = hex, score
			end
		end
	end

	if best_hex then
		used[best_hex] = true
		return best_hex
	end

	return fallback
end

-- }}}

---generate role color from candidates or hsv direct, with hue offset, adapated for bg, and ensure min contrast.
---@param candidates string[]
---@param target_hue number 0-360 the target hue
---@param bg string background color
---@param used table<string, boolean>
---@param sat number s of hsv
---@param val number v of hsv
---@param mix_ratio number 0.0 - 1.0
---@param contrast_ratio number minimum contrast to bg
---@param fallback? string fallback color
---@return string color hex string
function M.role_color(candidates, target_hue, bg, used, sat, val, mix_ratio, contrast_ratio, fallback) -- {{{
	local generated = M.hsv_to_hex(target_hue, sat, val)
	local source = M.pick_role_color(candidates, target_hue, bg, used, fallback or generated)
	if source and source ~= generated then
		generated = M.mix(generated, source, mix_ratio)
	end
	return M.ensure_contrast(generated, bg, contrast_ratio, 0.12)
end

-- }}}

-- }}}

-- OkLab {{{

-- https://bottosson.github.io/posts/oklab/

---Convert linear sRGB to OkLab.
---@param r number
---@param g number
---@param b number
---@return number L
---@return number a
---@return number b
function M.rgb_to_oklab(r, g, b) -- {{{
	local l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b
	local m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b
	local s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b

	local l_ = cbrtf(l)
	local m_ = cbrtf(m)
	local s_ = cbrtf(s)

	return
			0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_,
			1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_,
			0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_
end

-- }}}

---Convert linear OkLab to linear sRGB.
---@param L number
---@param a number
---@param b number
---@return number r
---@return number g
---@return number b
function M.oklab_to_rgb(L, a, b) -- {{{
	local l_ = L + 0.3963377774 * a + 0.2158037573 * b
	local m_ = L - 0.1055613458 * a - 0.0638541728 * b
	local s_ = L - 0.0894841775 * a - 1.2914855480 * b

	local l = l_ * l_ * l_
	local m = m_ * m_ * m_
	local s = s_ * s_ * s_

	return
			4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s,
			-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s,
			-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s
end

-- }}}

---Convert OkLab to OkLCH.
---@param L number
---@param a number
---@param b number
---@return number L
---@return number C
---@return number H
function M.oklab_to_oklch(L, a, b) -- {{{
	local C = math.sqrt(a * a + b * b)
	local H = math.atan(b, a) * 180 / math.pi
	if H < 0 then
		H = H + 360
	end
	return L, C, H
end

-- }}}

---Convert OkLCH to OkLab.
---@param L number
---@param C number
---@param H number
---@return number L
---@return number a
---@return number b
function M.oklch_to_oklab(L, C, H) -- {{{
	local rad = H * math.pi / 180
	return L, C * math.cos(rad), C * math.sin(rad)
end

-- }}}

return M
