-- ColorScheme.lua
-- tdf.ColorScheme class definition.

local h = require("color_helper")
local s = require("strategy")
---@diagnostic disable-next-line: unused-local
local logger = require("logger").get_logger()

---definations
---@diagnostic disable: unused-local

---@class tdf.Palette
---@field darker string[]
---@field lighter string[]
local Palette = {}
Palette.__index = Palette

---@class RoleColors
---@field error string
---@field ok string
---@field warning string
---@field info string
---@field hint string
---@field add string
---@field delete string
---@field change string
local RoleColors = {}
RoleColors.__index = RoleColors

---@class tdf.Ansi16
---@field protected new? fun(init: tdf.Ansi16|nil): tdf.Ansi16
---@field protected __pairs? fun(t: tdf.Ansi16): (fun(), tdf.Ansi16, nil)
---@field Black string
---@field Red string
---@field Green string
---@field Yellow string
---@field Blue string
---@field Magenta string
---@field Cyan string
---@field White string
---@field BrightBlack string
---@field BrightRed string
---@field BrightGreen string
---@field BrightYellow string
---@field BrightBlue string
---@field BrightMagenta string
---@field BrightCyan string
---@field BrightWhite string
local Ansi16 = {
	Black         = "#000000",
	Red           = "#800000",
	Green         = "#008000",
	Yellow        = "#808000",
	Blue          = "#000080",
	Magenta       = "#800080",
	Cyan          = "#008080",
	White         = "#c0c0c0",
	BrightBlack   = "#808080",
	BrightRed     = "#ff0000",
	BrightGreen   = "#00ff00",
	BrightYellow  = "#ffff00",
	BrightBlue    = "#0000ff",
	BrightMagenta = "#ff00ff",
	BrightCyan    = "#00ffff",
	BrightWhite   = "#ffffff",
}
local ansi16_order = {
	"Black", "Red", "Green", "Yellow", "Blue", "Magenta", "Cyan", "White",
	"BrightBlack", "BrightRed", "BrightGreen", "BrightYellow",
	"BrightBlue", "BrightMagenta", "BrightCyan", "BrightWhite",
}

Ansi16.__index = Ansi16
Ansi16.__pairs = function(t)
	local i = 0
	return function()
		i = i + 1
		local k = ansi16_order[i]
		if k then
			return k, t[k]
		end
	end, t, nil
end

function Ansi16.new(tbl)
	return setmetatable(tbl or {}, Ansi16)
end

---@class tdf.BackgroundColors
---@field common string
---@field elevated string
---@field hover string
---@field active string
---@field border string
---@field shadow string
local BackgroundColors = {}
BackgroundColors.__index = BackgroundColors

---@class tdf.ForegroundColors
---@field common string
---@field muted string
---@field subtle string
---@field hover string
---@field shadow string
local ForegroundColors = {}
ForegroundColors.__index = ForegroundColors

---@class tdf.SyntaxColors
---@field comment string
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
---@field keyword string
---@field keyword_flow string
---@field keyword_return string
local SyntaxColors = {}
SyntaxColors.__index = SyntaxColors

---@class tdf.ColorScheme
---@field dark_mode boolean         -- The day/night flag
---@field brand string              -- The brand color
---@field brand_palette tdf.Palette -- The palette of the brand color
---@field bg tdf.BackgroundColors   -- Background color Group
---@field fg tdf.ForegroundColors   -- Foreground color Group
---@field ansi16 tdf.Ansi16         -- The ANSI 16 color set
---@field role RoleColors           -- Role colors for diagnostics and diff
---@field syntax tdf.SyntaxColors   -- Syntax color Group
---@field candidates string[]       -- TODO: to be obsoleted
---@field accents string[]          -- TODO: to be obsoleted, use brand_palette field instead
---@field protected __index? tdf.ColorScheme
---@field protected new? fun(init: tdf.ColorScheme|nil): tdf.ColorScheme
local ColorScheme = {
	__name = "ColorScheme",
	__metatable = "ColorScheme class",
}
ColorScheme.__index = ColorScheme

---@diagnostic enable: unused-local

function ColorScheme.new(init)
	init = init or {}
	---@diagnostic disable-next-line: redundant-return-value
	return setmetatable(init, ColorScheme)
end

---@param self tdf.ColorScheme
---@return tdf.ColorScheme
function ColorScheme:build_ansi16()
	local used        = {}
	-- unpack
	local dark        = self.dark_mode
	local brand       = self.brand
	local bg          = self.bg.common
	local fg          = self.fg.common
	local candidates  = self.candidates

	-- local base_hue   = h.get_hue(brand) or 0
	local base_hue    = 0
	local black_slot  = dark and h.mix(bg, fg, 0.26) or h.mix(bg, fg, 0.68)
	local white_slot  = dark and h.mix(fg, bg, 0.18) or h.mix(fg, bg, 0.30)

	local role_color  = s.role_color

	---@type string[]
	local normal      = {}
	local hue_offsets = { 15, 135, 60, 225, 300, 185 }
	normal[1]         = s.ensure_contrast_soft(black_slot, bg, 1.8, 0.18)
	for i = 2, 7 do
		normal[i] = role_color(
			candidates,
			(base_hue + hue_offsets[i - 1]) % 360,
			bg,
			used,
			dark and 0.72 or 0.64,
			dark and 0.82 or 0.70,
			0.22,
			dark and 3.2 or 3.0,
			brand
		)
	end
	normal[8] = s.ensure_contrast(white_slot, bg, 4.5)

	---@type string[]
	local bright = {}
	bright[1] = s.ensure_contrast_soft(h.mix(normal[1], fg, dark and 0.28 or 0.18), bg, 2.4, 0.16)
	for i = 2, 7 do
		bright[i] = s.ensure_contrast_soft(h.mix(normal[i], fg, dark and 0.14 or 0.10), bg, 4.0, 0.14)
	end
	bright[8] = s.ensure_contrast(fg, bg, 7.0)

	self.ansi16 = Ansi16.new({
		Black         = normal[1],
		Red           = normal[2],
		Green         = normal[3],
		Yellow        = normal[4],
		Blue          = normal[5],
		Magenta       = normal[6],
		Cyan          = normal[7],
		White         = normal[8],
		BrightBlack   = bright[1],
		BrightRed     = bright[2],
		BrightGreen   = bright[3],
		BrightYellow  = bright[4],
		BrightBlue    = bright[5],
		BrightMagenta = bright[6],
		BrightCyan    = bright[7],
		BrightWhite   = bright[8],
	})
	return self
end

---@param self tdf.ColorScheme
---@return tdf.ColorScheme
function ColorScheme:build_syntax()
	local A = self.ansi16
	local bg = self.bg.common
	local fg = self.fg.common
	self.syntax = {
		comment        = h.mix(fg, bg, 0.5),
		keyword        = A.Magenta,
		keyword_flow   = s.ensure_contrast_soft(h.mix(A.Yellow, A.Red, 0.20), bg, 4.4, 0.14),
		keyword_return = s.ensure_contrast_soft(h.mix(A.Magenta, A.Red, 0.35), bg, 4.6, 0.14),
		string         = A.Green,
		number         = A.Yellow,
		type           = A.Blue,
		func           = A.Cyan,
		func_call      = s.ensure_contrast_soft(h.mix(A.Cyan, fg, 0.10), bg, 4.8, 0.14),
		variable       = self.fg.hover,
		constant       = s.ensure_contrast_soft(h.mix(A.Yellow, A.Red, 0.25), bg, 4.2, 0.14),
		macro          = A.Red,
		builtin        = s.ensure_contrast_soft(h.mix(A.Red, A.Yellow, 0.45), bg, 4.4, 0.14),
		property       = A.Cyan,
		parameter      = s.ensure_contrast_soft(h.mix(A.Cyan, A.Blue, 0.38), bg, 4.4, 0.14),
		operator       = self.fg.subtle,
		punctuation    = self.fg.subtle,
		namespace      = s.ensure_contrast_soft(h.mix(A.Blue, A.Magenta, 0.32), bg, 4.4, 0.14),
	}
	return self
end

function ColorScheme:build_role()
	local A   = self.ansi16
	self.role = {
		error   = A.Red,
		ok      = A.Green,
		warning = A.Yellow,
		info    = A.Cyan,
		hint    = A.White,
		add     = A.Green,
		delete  = A.Red,
		change  = A.Blue,
	}
	return self
end

--- Factory function creates a ColorScheme instance from dominant color list.
--- @param dominants string[] list of hex string
--- @param invert_bool boolean|nil invert day/night mode, default is false (true to be opposite to wallpaper)
--- @return tdf.ColorScheme
function ColorScheme.from_dominants(dominants, invert_bool)
	invert_bool = invert_bool or false
	-- sort by luma (dark -> light)
	local sorted = s.unique_colors(dominants)
	table.sort(sorted, function(a, b)
		return h.get_luma(a) < h.get_luma(b)
	end)

	-- dark mode or not
	local median       = sorted[math.ceil(#sorted / 2)]
	local wall_is_dark = s.is_dark(median)
	local dark_mode    = invert_bool and not wall_is_dark or wall_is_dark -- invert ? !wall : wall

	-- bg & fg
	local bg           = dark_mode and sorted[1] or sorted[#sorted]
	local fg           = s.ensure_contrast(dark_mode and sorted[#sorted] or sorted[1], bg, 7.0)

	local bg_elevated  = h.mix(bg, fg, dark_mode and 0.10 or 0.08)
	local bg_hover     = h.mix(bg, fg, dark_mode and 0.15 or 0.12)
	local bg_active    = h.mix(bg, fg, dark_mode and 0.22 or 0.18)
	local bg_border    = h.mix(bg, fg, dark_mode and 0.28 or 0.24)
	local bg_shadow    = dark_mode and "#101010" or "#bfb7af"

	local fg_muted     = s.ensure_contrast(h.mix(fg, bg, 0.35), bg, 4.5)
	local fg_subtle    = s.ensure_contrast(h.mix(fg, bg, 0.48), bg, 3.2)
	local fg_hover     = s.ensure_contrast(h.mix(fg, bg, 0.14), bg, 6.0)
	local fg_shadow    = dark_mode and "rgba(0, 0, 0, 0.377)" or bg

	-- candidates
	local candidates   = {}
	for _, hex in ipairs(dominants) do
		if h.get_distance(hex, bg) >= 28 and h.get_distance(hex, fg) >= 24 then
			candidates[#candidates + 1] = hex
		end
	end
	table.sort(candidates, function(a, b)
		local score_a = h.get_chroma(a) * 1.6 + h.get_distance(a, bg) * 0.35 + math.min(h.get_contrast(a, bg), 6) * 14
		local score_b = h.get_chroma(b) * 1.6 + h.get_distance(b, bg) * 0.35 + math.min(h.get_contrast(b, bg), 6) * 14
		return score_a > score_b
	end)

	-- accents
	local accents = {}
	for _, hex in ipairs(candidates) do
		if s.push_if_varied(accents, hex, 36, 28) and #accents >= 6 then
			break
		end
	end

	local accent_seed = accents[1] or sorted[math.floor(#sorted / 2)] or fg
	local accent = s.ensure_contrast_soft(accent_seed, bg, 2.6, 0.16)

	local fallback_accents = {
		accent,
		s.ensure_contrast_soft(h.mix(accent, fg, 0.25), bg, 3.0, 0.16),
		s.ensure_contrast_soft(h.mix(accent, bg, 0.25), bg, 2.0, 0.16),
		s.ensure_contrast_soft(h.mix(accent, fg, 0.45), bg, 2.4, 0.16),
		s.ensure_contrast_soft(h.mix(accent, bg, 0.45), bg, 1.8, 0.16),
		s.ensure_contrast_soft(h.mix(sorted[#sorted], bg, 0.35), bg, 3.0, 0.16),
	}

	for _, hex in ipairs(fallback_accents) do
		if #accents >= 6 then
			break
		end
		s.push_if_varied(accents, hex, 18, 12)
	end

	while #accents < 6 do
		accents[#accents + 1] = s.ensure_contrast_soft(h.mix(accent, fg, 0.12 * #accents), bg, 2.0, 0.16)
	end

	-- new instance
	---@diagnostic disable: assign-type-mismatch
	---@diagnostic disable-next-line: missing-fields
	return ColorScheme.new({
		dark_mode  = dark_mode,
		bg         = {
			common   = bg,
			elevated = bg_elevated,
			hover    = bg_hover,
			active   = bg_active,
			border   = bg_border,
			shadow   = bg_shadow,
		},
		fg         = {
			common = fg,
			muted  = fg_muted,
			subtle = fg_subtle,
			hover  = fg_hover,
			shadow = fg_shadow,
		},
		brand      = accent,
		candidates = candidates,
		accents    = accents,
		ansi16     = nil,
		syntax     = nil,
	}):build_ansi16():build_syntax():build_role()
	---@diagnostic enable: assign-type-mismatch
end

return ColorScheme.from_dominants
