-- ColorScheme.lua
-- tdf.ColorScheme class definition.

-- vim:foldmethod=marker:foldmarker=#region,#endregion

local h = require("color_helper")
local ensure_contrast = h.ensure_contrast
local role_color = h.role_color
local mix = h.mix
local distance = h.get_distance
local chroma = h.get_chroma
local luma = h.get_luma
local contrast = h.get_contrast

---@diagnostic disable-next-line: unused-local
local logger = require("logger").get_logger()

--#region declarations

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
---@field bool string
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

---@type table<string, tdf.SyntaxColors>
local SyntaxThemes = {
	["RiderIslands"] = {
		comment        = "#85c46c",
		operator       = "#bdbdbd",
		punctuation    = "#bdbdbd",
		constant       = "#66c3cc",
		string         = "#c9a26d",
		number         = "#ed94c0",
		bool           = "#ed94c0",
		variable       = "#bdbdbd",
		func           = "#39cc9b",
		func_call      = "#39cc9b",
		keyword        = "#6c95eb",
		keyword_flow   = "#6c95eb",
		keyword_return = "#6c95eb",
		macro          = "#6c95eb",
		type           = "#c191ff",
		namespace      = "#c191ff",
		builtin        = "#f0f0f0",
		parameter      = "#bdbdbd",
		property       = "#66c3cc",
	},

	["Sonokai"] = {
		comment        = "#7f8490",
		operator       = "#ff75a0",
		punctuation    = "#e2e2e3",
		constant       = "#e2e2e3",
		string         = "#9ece6a",
		number         = "#e2e2e3",
		bool           = "#ff75a0",
		variable       = "#e2e2e3",
		func           = "#9dbbd0",
		func_call      = "#9dbbd0",
		keyword        = "#ff75a0",
		keyword_flow   = "#ff75a0",
		keyword_return = "#ff75a0",
		macro          = "#ff75a0",
		type           = "#9dbbd0",
		namespace      = "#9dbbd0",
		builtin        = "#ff75a0",
		parameter      = "#e2e2e3",
		property       = "#9ece6a",
	},
	["TokyoNight"] = {
		comment        = "#565f89",
		operator       = "#89ddff",
		punctuation    = "#c0caf5",
		constant       = "#bb9af7",
		string         = "#9ece6a",
		number         = "#ff9e64",
		bool           = "#ff9e64",
		variable       = "#c0caf5",
		func           = "#7aa2f7",
		func_call      = "#7aa2f7",
		keyword        = "#bb9af7",
		keyword_flow   = "#bb9af7",
		keyword_return = "#bb9af7",
		macro          = "#89ddff",
		type           = "#2ac3de",
		namespace      = "#7aa2f7",
		builtin        = "#ff9e64",
		parameter      = "#c0caf5",
		property       = "#73daca",
	},
	["Dracula"] = {
		comment        = "#6272a4",
		operator       = "#ff79c6",
		punctuation    = "#f8f8f2",
		constant       = "#bd93f9",
		string         = "#f1fa8c",
		number         = "#bd93f9",
		bool           = "#bd93f9",
		variable       = "#f8f8f2",
		func           = "#50fa7b",
		func_call      = "#50fa7b",
		keyword        = "#ff79c6",
		keyword_flow   = "#ff79c6",
		keyword_return = "#ff79c6",
		macro          = "#ff79c6",
		type           = "#8be9fd",
		namespace      = "#8be9fd",
		builtin        = "#8be9fd",
		parameter      = "#f8f8f2",
		property       = "#f1fa8c",
	},
	["Material"] = {
		comment        = "#707880",
		operator       = "#89ddff",
		punctuation    = "#eeffff",
		constant       = "#f78c6c",
		string         = "#c3e88d",
		number         = "#f78c6c",
		bool           = "#f78c6c",
		variable       = "#eeffff",
		func           = "#82aaff",
		func_call      = "#82aaff",
		keyword        = "#c792ea",
		keyword_flow   = "#c792ea",
		keyword_return = "#c792ea",
		macro          = "#89ddff",
		type           = "#ffcb6b",
		namespace      = "#82aaff",
		builtin        = "#ffcb6b",
		parameter      = "#eeffff",
		property       = "#c3e88d",
	}
}

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
local ColorScheme = {
	---@package
	__name = "ColorScheme",
	---@package
	__metatable = "ColorScheme class",
}
---@package
ColorScheme.__index = ColorScheme

---@allnullable tdf.ColorScheme

---@diagnostic enable: unused-local

--#endregion

---@package
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
	local black_slot  = dark and mix(bg, fg, 0.26) or mix(bg, fg, 0.68)
	local white_slot  = dark and mix(fg, bg, 0.18) or mix(fg, bg, 0.30)

	---@type string[]
	local normal      = {}
	local hue_offsets = { 15, 135, 60, 225, 300, 185 }
	normal[1]         = ensure_contrast(black_slot, bg, 1.8, 0.18)
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
	normal[8] = ensure_contrast(white_slot, bg, 4.5)

	---@type string[]
	local bright = {}
	bright[1] = ensure_contrast(mix(normal[1], fg, dark and 0.28 or 0.18), bg, 2.4, 0.16)
	for i = 2, 7 do
		bright[i] = ensure_contrast(mix(normal[i], fg, dark and 0.14 or 0.10), bg, 4.0, 0.14)
	end
	bright[8] = ensure_contrast(fg, bg, 7.0)

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
---@param theme string|nil
---@return tdf.ColorScheme
function ColorScheme:build_syntax(theme)
	if theme ~= nil and SyntaxThemes[theme] ~= nil then
		self.syntax = SyntaxThemes[theme]
		return self
	end
	local A = self.ansi16
	local bg = self.bg.common
	local fg = self.fg.common
	self.syntax = {
		comment        = mix(fg, bg, 0.5),
		operator       = self.fg.subtle,
		punctuation    = self.fg.subtle,
		constant       = ensure_contrast(h.mix(A.Yellow, A.Red, 0.25), bg, 4.2, 0.14),
		string         = A.Green,
		number         = A.Yellow,
		bool           = ensure_contrast(h.mix(A.Red, A.Yellow, 0.45), bg, 4.4, 0.14),
		variable       = self.fg.hover,
		func           = A.Cyan,
		func_call      = ensure_contrast(h.mix(A.Cyan, fg, 0.10), bg, 4.8, 0.14),
		keyword        = A.Magenta,
		keyword_flow   = ensure_contrast(h.mix(A.Yellow, A.Red, 0.20), bg, 4.4, 0.14),
		keyword_return = ensure_contrast(h.mix(A.Magenta, A.Red, 0.35), bg, 4.6, 0.14),
		macro          = A.Red,
		type           = A.Blue,

		namespace      = ensure_contrast(h.mix(A.Blue, A.Magenta, 0.32), bg, 4.4, 0.14),
		builtin        = ensure_contrast(h.mix(A.Red, A.Yellow, 0.45), bg, 4.4, 0.14),
		parameter      = ensure_contrast(h.mix(A.Cyan, A.Blue, 0.38), bg, 4.4, 0.14),
		property       = A.Cyan,
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

---@class tdf.ColorAutoGenOpts
---@field enable? boolean Generate colors or not when changing wallpaper
---@field notify? boolean Send notification or not
---@field theme_mode? "auto"|"invert"|"dark"|"light"
---@field syntax_theme? string|"Sonokai"|"RiderIslands"|"Material"|"TokyoNight" Force name of the syntax theme
---@field tasks? table<string, GenerationTask> List of serialization tasks
---@field force? tdf.ColorSchemeAllNullable Force use the fields in this scheme, only bg.common and fg.common are worked for now
---@field on_reload? fun(cs: tdf.ColorScheme)

---@package
---Factory function creates a ColorScheme instance from dominant color list.
---@param dominants string[] list of hex string
---@param opts tdf.ColorAutoGenOpts|nil
---@return tdf.ColorScheme
function ColorScheme.from_dominants(dominants, opts)
	if #dominants < 4 then
		logger:error("Not enough colors sampled from image")
	end

	opts = opts or {}
	-- force
	local force = opts.force or {}
	---@cast force +tdf.ColorScheme
	---@cast force -tdf.ColorSchemeAllNullable
	local theme_mode = opts.theme_mode or "auto"
	local bg_force = force.bg and force.bg.common or nil
	local fg_force = force.fg and force.fg.common or nil

	-- sort by luma (dark -> light)
	local sorted = h.unique_colors(dominants)
	table.sort(sorted, function(a, b)
		return luma(a) < luma(b)
	end)

	-- dark theme or not
	local median       = sorted[math.ceil(#sorted / 2)]
	local wall_is_dark = h.is_dark(median)
	local dark_theme
	if theme_mode == "auto" then
		dark_theme = wall_is_dark
	elseif theme_mode == "invert" then
		dark_theme = not wall_is_dark
	elseif theme_mode == "dark" then
		dark_theme = true
	elseif theme_mode == "light" then
		dark_theme = false
	else
		dark_theme = wall_is_dark
	end

	-- bg & fg
	-- TODO: 这里只是为了让壁纸是亮色而config设置强制暗色后背景更深，但也会影响壁纸本身是暗色的情况，这种情况不需要
	local bg_common   = bg_force or (dark_theme and h.change_lightness(sorted[1], 0.15) or sorted[#sorted])
	local fg_common   = fg_force or ensure_contrast(dark_theme and sorted[#sorted] or sorted[1], bg_common, 7.0)

	local bg_elevated = mix(bg_common, fg_common, dark_theme and 0.10 or 0.08)
	local bg_hover    = mix(bg_common, fg_common, dark_theme and 0.15 or 0.12)
	local bg_active   = mix(bg_common, fg_common, dark_theme and 0.22 or 0.18)
	local bg_border   = mix(bg_common, fg_common, dark_theme and 0.28 or 0.24)
	local bg_shadow   = dark_theme and "#101010" or "#bfb7af"

	local fg_muted    = ensure_contrast(mix(fg_common, bg_common, 0.35), bg_common, 4.5)
	local fg_subtle   = ensure_contrast(mix(fg_common, bg_common, 0.48), bg_common, 3.2)
	local fg_hover    = ensure_contrast(mix(fg_common, bg_common, 0.14), bg_common, 6.0)
	local fg_shadow   = dark_theme and "#000000" or bg_common

	-- candidates
	local candidates  = {}
	for _, hex in ipairs(dominants) do
		if distance(hex, bg_common) >= 28 and distance(hex, fg_common) >= 24 then
			candidates[#candidates + 1] = hex
		end
	end
	table.sort(candidates, function(a, b)
		local score_a = chroma(a) * 1.6 + distance(a, bg_common) * 0.35 + math.min(contrast(a, bg_common), 6) * 14
		local score_b = chroma(b) * 1.6 + distance(b, bg_common) * 0.35 + math.min(contrast(b, bg_common), 6) * 14
		return score_a > score_b
	end)

	-- accents
	local accents = {}
	for _, hex in ipairs(candidates) do
		if h.push_if_varied(accents, hex, 36, 28) and #accents >= 6 then
			break
		end
	end

	local accent_seed = accents[1] or sorted[math.floor(#sorted / 2)] or fg_common
	local accent = ensure_contrast(accent_seed, bg_common)

	local fallback_accents = {
		accent,
		ensure_contrast(mix(accent, fg_common, 0.25), bg_common, 3.0, 0.16),
		ensure_contrast(mix(accent, bg_common, 0.25), bg_common, 2.0, 0.16),
		ensure_contrast(mix(accent, fg_common, 0.45), bg_common, 2.4, 0.16),
		ensure_contrast(mix(accent, bg_common, 0.45), bg_common, 1.8, 0.16),
		ensure_contrast(mix(sorted[#sorted], bg_common, 0.35), bg_common, 3.0, 0.16),
	}

	for _, hex in ipairs(fallback_accents) do
		if #accents >= 6 then
			break
		end
		h.push_if_varied(accents, hex, 18, 12)
	end

	while #accents < 6 do
		accents[#accents + 1] = ensure_contrast(mix(accent, fg_common, 0.12 * #accents), bg_common, 2.0, 0.16)
	end

	-- new instance
	---@diagnostic disable: assign-type-mismatch
	---@diagnostic disable-next-line: missing-fields
	return ColorScheme.new({
		dark_mode  = dark_theme,
		bg         = {
			common   = bg_common,
			elevated = bg_elevated,
			hover    = bg_hover,
			active   = bg_active,
			border   = bg_border,
			shadow   = bg_shadow,
		},
		fg         = {
			common = fg_common,
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
	}):build_ansi16():build_syntax(opts.syntax_theme):build_role()
	---@diagnostic enable: assign-type-mismatch
end

return ColorScheme.from_dominants
