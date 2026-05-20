-- colors.lua
local h = require("helper")
local s = require("strategy")

---@class tdf.Colors
---@field dark_mode boolean
---@field bg string
---@field fg string
---@field bg_elevated string
---@field bg_hover string
---@field bg_active string
---@field bg_border string
---@field bg_shadow string
---@field fg_muted string
---@field fg_subtle string
---@field fg_hover string
---@field fg_shadow string
---@field accent string
---@field accent_soft string
---@field accent_strong string
---@field accent_fg string
---@field accents string[]
---@field ansi_normal string[8]
---@field ansi_bright string[8]
---@field syntax tdf.Colors.SyntaxColors
---@field preview? string[]

---@class tdf.Colors.SyntaxColors
---@field keyword string
---@field keyword_flow string
---@field keyword_return string
---@field string string
---@field number string
---@field type string
---@field func string
---@field func_call string
---@field variable string
---@field constant string
---@field macro string
---@field builtin string
---@field property string
---@field parameter string
---@field operator string
---@field punctuation string
---@field namespace string

local M = {}

--- Build terminal palette from dominant colors.
--- @param p tdf.Colors
--- @param candidates string[]
--- @return string[] ansi_normal
--- @return string[] ansi_bright
--- @return tdf.Colors.SyntaxColors syntax
local function build_ansi16(p, candidates)
	local used = {}
	local dark = p.dark_mode
	local seed = p.accent
	local base_hue = h.get_hue(seed) or h.get_hue(p.accents[1] or seed) or 0

	local function role_color(hue_offset, sat, val, mix_ratio, contrast_ratio, fallback)
		local target_hue = (base_hue + hue_offset) % 360
		local generated = h.hsv_to_hex(target_hue, sat, val)
		local source = s.pick_role_color(candidates, p.bg, used, target_hue, fallback or generated)
		if source and source ~= generated then
			generated = h.mix(generated, source, mix_ratio or 0.25)
		end
		return s.lift_contrast(generated, p.bg, contrast_ratio or (dark and 3.2 or 3.0), 0.12)
	end

	local black_slot = dark and h.mix(p.bg, p.fg, 0.26) or h.mix(p.bg, p.fg, 0.68)
	local white_slot = dark and h.mix(p.fg, p.bg, 0.18) or h.mix(p.fg, p.bg, 0.30)

  ---@type string[]
	local normal = {}
	normal[1] = s.lift_contrast(black_slot, p.bg, 1.8, 0.18)
	normal[2] =
		role_color(15, dark and 0.78 or 0.70, dark and 0.84 or 0.72, 0.22, dark and 3.2 or 3.0, p.accents[1] or seed)
	normal[3] =
		role_color(135, dark and 0.72 or 0.66, dark and 0.82 or 0.70, 0.22, dark and 3.2 or 3.0, p.accents[2] or seed)
	normal[4] =
		role_color(60, dark and 0.78 or 0.68, dark and 0.86 or 0.74, 0.20, dark and 3.0 or 2.8, p.accents[3] or seed)
	normal[5] =
		role_color(225, dark and 0.72 or 0.64, dark and 0.82 or 0.70, 0.22, dark and 3.2 or 3.0, p.accents[4] or seed)
	normal[6] =
		role_color(300, dark and 0.76 or 0.68, dark and 0.84 or 0.72, 0.22, dark and 3.2 or 3.0, p.accents[5] or seed)
	normal[7] =
		role_color(185, dark and 0.74 or 0.66, dark and 0.82 or 0.70, 0.22, dark and 3.2 or 3.0, p.accents[6] or seed)
	normal[8] = s.ensure_contrast(white_slot, p.bg, 4.5)

  ---@type string[]
	local bright = {}
	bright[1] = s.lift_contrast(h.mix(normal[1], p.fg, dark and 0.28 or 0.18), p.bg, 2.4, 0.16)
	for i = 2, 7 do
		bright[i] = s.lift_contrast(h.mix(normal[i], p.fg, dark and 0.14 or 0.10), p.bg, 4.0, 0.14)
	end
	bright[8] = s.ensure_contrast(p.fg, p.bg, 7.0)

  ---@type tdf.Colors.SyntaxColors
	local syntax = {
		keyword = normal[6],
		keyword_flow = s.lift_contrast(h.mix(normal[4], normal[2], 0.20), p.bg, 4.4, 0.14),
		keyword_return = s.lift_contrast(h.mix(normal[6], normal[2], 0.35), p.bg, 4.6, 0.14),
		string = normal[3],
		number = normal[4],
		type = normal[5],
		func = normal[7],
		func_call = s.lift_contrast(h.mix(normal[7], p.fg, 0.10), p.bg, 4.8, 0.14),
		variable = p.fg_hover,
		constant = s.lift_contrast(h.mix(normal[4], normal[2], 0.25), p.bg, 4.2, 0.14),
		macro = normal[2],
		builtin = s.lift_contrast(h.mix(normal[2], normal[4], 0.45), p.bg, 4.4, 0.14),
		property = normal[7],
		parameter = s.lift_contrast(h.mix(normal[7], normal[5], 0.38), p.bg, 4.4, 0.14),
		operator = p.fg_subtle,
		punctuation = p.fg_subtle,
		namespace = s.lift_contrast(h.mix(normal[5], normal[6], 0.32), p.bg, 4.4, 0.14),
	}

	return normal, bright, syntax
end

--- Build a full palette from dominant sampled colors.
--- @param dominant_colors string[] a color list
--- @param invert boolean|nil invert day/night mode, default is true (opposite to wallpaper)
--- @return tdf.Colors
function M.from_dominant_colors(dominant_colors, invert)
  -- sort by luma (dark -> light)
	local sorted = s.unique_colors(dominant_colors)
	table.sort(sorted, function(a, b)
		return h.get_luma(a) < h.get_luma(b)
	end)

  -- day/night
	local median = sorted[math.ceil(#sorted / 2)]
	local wallpaper_is_dark = h.get_luma(median) < 140
	local invert_theme = invert or true
	local dark_mode = invert_theme and not wallpaper_is_dark or wallpaper_is_dark

  -- bg & fg
	local bg = dark_mode and sorted[1] or sorted[#sorted]
	local fg_origin = dark_mode and sorted[#sorted] or sorted[1]
	local fg = s.ensure_contrast(fg_origin, bg, 7.0)

	local bg_elevated = h.mix(bg, fg, dark_mode and 0.10 or 0.08)
	local bg_hover = h.mix(bg, fg, dark_mode and 0.15 or 0.12)
	local bg_active = h.mix(bg, fg, dark_mode and 0.22 or 0.18)
	local bg_border = h.mix(bg, fg, dark_mode and 0.28 or 0.24)

	local fg_muted = s.ensure_contrast(h.mix(fg, bg, 0.35), bg, 4.5)
	local fg_subtle = s.ensure_contrast(h.mix(fg, bg, 0.48), bg, 3.2)
	local fg_hover = s.ensure_contrast(h.mix(fg, bg, 0.14), bg, 6.0)
	local bg_shadow = dark_mode and "#101010" or "#bfb7af"
	local fg_shadow = dark_mode and "rgba(0, 0, 0, 0.377)" or bg

  -- accents
	local candidates = {}
	for _, hex in ipairs(dominant_colors) do
		if h.get_distance(hex, bg) >= 28 and h.get_distance(hex, fg) >= 24 then
			candidates[#candidates + 1] = hex
		end
	end

	table.sort(candidates, function(a, b)
		local score_a = h.get_chroma(a) * 1.6 + h.get_distance(a, bg) * 0.35 + math.min(h.get_contrast(a, bg), 6) * 14
		local score_b = h.get_chroma(b) * 1.6 + h.get_distance(b, bg) * 0.35 + math.min(h.get_contrast(b, bg), 6) * 14
		return score_a > score_b
	end)

	local accents = {}
	for _, hex in ipairs(candidates) do
		if s.push_if_varied(accents, hex, 36, 28) and #accents >= 6 then
			break
		end
	end

	-- Fallbacks
	local accent_seed = accents[1] or sorted[math.floor(#sorted / 2)] or fg
	local accent = s.lift_contrast(accent_seed, bg, 2.6, 0.16)

	local fallback_accents = {
		accent,
		s.lift_contrast(h.mix(accent, fg, 0.25), bg, 3.0, 0.16),
		s.lift_contrast(h.mix(accent, bg, 0.25), bg, 2.0, 0.16),
		s.lift_contrast(h.mix(accent, fg, 0.45), bg, 2.4, 0.16),
		s.lift_contrast(h.mix(accent, bg, 0.45), bg, 1.8, 0.16),
		s.lift_contrast(h.mix(sorted[#sorted], bg, 0.35), bg, 3.0, 0.16),
	}

	for _, hex in ipairs(fallback_accents) do
		if #accents >= 6 then
			break
		end
		s.push_if_varied(accents, hex, 18, 12)
	end

	while #accents < 6 do
		accents[#accents + 1] = s.lift_contrast(h.mix(accent, fg, 0.12 * #accents), bg, 2.0, 0.16)
	end

  ---@type tdf.Colors
	local p = {
		dark_mode = dark_mode,
		bg = bg,
		fg = fg,
		bg_elevated = bg_elevated,
		bg_hover = bg_hover,
		bg_active = bg_active,
		bg_border = bg_border,
		bg_shadow = bg_shadow,
		fg_muted = fg_muted,
		fg_subtle = fg_subtle,
		fg_hover = fg_hover,
		fg_shadow = fg_shadow,
		accent = accent,
		accent_soft = s.lift_contrast(h.mix(accent, bg, 0.25), bg, 2.0, 0.16),
		accent_strong = s.lift_contrast(h.mix(accent, fg, 0.25), bg, 3.0, 0.16),
		accent_fg = s.ensure_contrast(s.best_text(accent), accent, 4.5),
		accents = accents,
    ansi_normal = nil,
    ansi_bright = nil,
    syntax = nil
	}

	p.ansi_normal, p.ansi_bright, p.syntax = build_ansi16(p, candidates)

	-- Preview build
	p.preview = { bg, fg, accent }
	for _, a in ipairs(accents) do
		local distinct = true
		for _, seen in ipairs(p.preview) do
			if h.get_distance(seen, a) < 8 then
				distinct = false
				break
			end
		end
		if distinct then
			table.insert(p.preview, a)
		end
	end

	return p
end

return M
