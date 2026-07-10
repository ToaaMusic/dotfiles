-- strategy.lua
-- color generation strategy on top of color_helper

local h = require("color_helper")

local M = {}

---return true if the hex is dark (luminance < 0.5)
---@param hex string
---@return boolean is_dark
function M.is_dark(hex)
	return h.get_luminance(hex) < 0.5

	-- return h.get_luma(hex) < 140

	-- local black, white = "#000000", "#ffffff"
	-- return h.get_contrast(black, bg_hex) <= h.get_contrast(white, bg_hex)
end

---return bg is dark ? "#ffffff" : "#000000"
---@param bg_hex string
---@return string color black/white
function M.best_text(bg_hex)
	local black, white = "#000000", "#ffffff"
	return M.is_dark(bg_hex) and white or black
end

---lift a contrast ratio >= min_ratio by gradually mixing toward best_text.
---@param fg string
---@param bg string
---@param min_ratio number|nil default 4.5
---@param step number|nil default 0.35
---@return string color fg after lifting contrast.
function M.ensure_contrast(fg, bg, min_ratio, step)
	min_ratio = min_ratio or 4.5
	step = step or 0.35
	if h.get_contrast(fg, bg) >= min_ratio then
		return fg
	end

	local current, best = fg, M.best_text(bg)
	for _ = 1, 10 do
		current = h.mix(current, best, step)
		if h.get_contrast(current, bg) >= min_ratio then
			return current
		end
	end
	return best
end

---lift contrast by gradually mixing toward best_text.
---@param fg string
---@param bg string
---@param min_ratio number|nil default 2.8
---@param step number|nil default 0.16
---@return string color fg after lifting contrast.
function M.ensure_contrast_soft(fg, bg, min_ratio, step)
	min_ratio = min_ratio or 2.8
	step = step or 0.16
	if h.get_contrast(fg, bg) >= min_ratio then
		return fg
	end

	local current, best = fg, M.best_text(bg)
	for _ = 1, 12 do
		current = h.mix(current, best, step)
		if h.get_contrast(current, bg) >= min_ratio then
			return current
		end
	end
	return current
end

-- [[ Collection Utils ]]

--- Generate an array of color strings by interpolating between two hex colors
---@param color1 string First hex color
---@param color2 string Second hex color
---@param length number Number of colors to generate
---@return string[] Array of hex color strings
function M.gradient(color1, color2, length)
	local colors = {}

	for i = 1, length do
		local ratio = (i - 1) / (length - 1)
		colors[i] = h.mix(color1, color2, ratio)
	end

	return colors
end

---filter identical colors
---@param colors string[] hex color list
---@return string[] colors filtered identical hex color list
function M.unique_colors(colors)
	local out, seen = {}, {}
	for _, hex in ipairs(colors) do
		local key = hex:lower()
		if not seen[key] then
			seen[key] = true
			out[#out + 1] = hex
		end
	end
	return out
end

---push if distinct in overall distance and hue.
---@param out string[] the list to push in
---@param hex string the color to push
---@param min_dist number|nil minimum distance, default 36
---@param min_hue_dist number|nil minimum hue distance, default 28
---@return boolean
function M.push_if_varied(out, hex, min_dist, min_hue_dist)
	min_dist = min_dist or 36
	min_hue_dist = min_hue_dist or 28
	local hue = h.get_hue(hex)
	for _, existing in ipairs(out) do
		if h.get_distance(existing, hex) < min_dist then
			return false
		end
		if hue and h.get_hue(existing) and h.get_hue_distance(existing, hex) < min_hue_dist then
			return false
		end
	end
	out[#out + 1] = hex
	return true
end

---score a hex for role priority (sum of hue match, chroma, contrast to bg).
---@param hex string the color to be scored
---@param target_hue number the target hue
---@param bg string the background color to compute contrast
---@return number score
function M.score_role(hex, target_hue, bg)
	local hue = h.get_hue(hex)

	-- hue match score
	local hue_score = 0
	if hue then
		local diff = math.abs(hue - target_hue)
		hue_score = (180 - math.min(diff, 360 - diff)) * 0.9
	end

	local chroma_score = h.get_chroma(hex) * 0.7
	local contrast_to_bg_score = math.min(h.get_contrast(hex, bg), 6) * 16
	return hue_score + chroma_score + contrast_to_bg_score
end

---pick highest scored color using score_role from candidates that isn't used.
---@param candidates string[] the list of candidates to rank.
---@param bg string the background color to compute contrast
---@param used table<string, boolean>
---@param target_hue number 0-360 the target hue
---@param fallback string fallback color
---@return string color best hex
function M.pick_role_color(candidates, target_hue, bg, used, fallback)
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
function M.role_color(candidates, target_hue, bg, used, sat, val, mix_ratio, contrast_ratio, fallback)
	local generated = h.hsv_to_hex(target_hue, sat, val)
	local source = M.pick_role_color(candidates, target_hue, bg, used, fallback or generated)
	if source and source ~= generated then
		generated = h.mix(generated, source, mix_ratio)
	end
	return M.ensure_contrast_soft(generated, bg, contrast_ratio, 0.12)
end

return M
