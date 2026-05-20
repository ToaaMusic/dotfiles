-- strategy.lua
local h = require("helper")

local M = {}

---return black or white from bg
---@param bg string
---@return string color black/white
function M.best_text(bg)
	local black, white = "#000000", "#ffffff"
	return h.get_contrast(black, bg) >= h.get_contrast(white, bg) and black or white
end

---ensure a contrast ratio >= 4.5 by mixing toward best_text.
---@param fg string
---@param bg string
---@param min_ratio number
---@return string color
function M.ensure_contrast(fg, bg, min_ratio)
	min_ratio = min_ratio or 4.5
	if h.get_contrast(fg, bg) >= min_ratio then
		return fg
	end

	local target = M.best_text(bg)
	local current = fg
	for _ = 1, 10 do
		current = h.mix(current, target, 0.35)
		if h.get_contrast(current, bg) >= min_ratio then
			return current
		end
	end
	return target
end

---lift contrast by gradually mixing toward best_text.
---@param hex string
---@param bg string
---@param min_ratio? number
---@param step number
---@return string color
function M.lift_contrast(hex, bg, min_ratio, step)
	min_ratio = min_ratio or 2.8
	step = step or 0.16
	if h.get_contrast(hex, bg) >= min_ratio then
		return hex
	end

	local current, target = hex, M.best_text(bg)
	for _ = 1, 12 do
		current = h.mix(current, target, step)
		if h.get_contrast(current, bg) >= min_ratio then
			return current
		end
	end
	return current
end

-- [[ Collection Utils ]]

---filter identical colors
---@param colors string[]
---@return string[]
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
---@param out string[]
---@param hex string
---@param min_dist number
---@param min_hue_dist number
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

---score a hex for role priority.
---@param hex string
---@param target_hue number|nil
---@param bg string
---@return number
function M.role_score(hex, target_hue, bg)
	local hue = h.get_hue(hex)
	local hue_score = 0
	if hue then
		local diff = math.abs(hue - target_hue)
		hue_score = (180 - math.min(diff, 360 - diff)) * 0.9
	end

	return hue_score + h.get_chroma(hex) * 0.7 + math.min(h.get_contrast(hex, bg), 6) * 16
end

---pick highest scored candidate that isn't used.
---@param candidates string[]
---@param bg string
---@param used table<string, boolean>
---@param target_hue number
---@param fallback string
---@return string
function M.pick_role_color(candidates, bg, used, target_hue, fallback)
	local best_hex, best_score
	for _, hex in ipairs(candidates) do
		if not used[hex] then
			local score = M.role_score(hex, target_hue, bg)
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

return M
