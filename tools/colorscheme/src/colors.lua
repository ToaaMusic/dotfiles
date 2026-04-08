local helper = require("helper")

local M = {}

-- internal

local best_text_on = helper.best_text_on
local chroma = helper.chroma
local color_distance = helper.color_distance
local contrast_ratio = helper.contrast_ratio
local ensure_contrast = helper.ensure_contrast
local hue_degrees = helper.hue_degrees
local hue_distance = helper.hue_distance
local lift_contrast = helper.lift_contrast
local luma = helper.luma
local mix = helper.mix

local function copy_table(t)
  local out = {}
  for i, v in ipairs(t) do
    out[i] = v
  end
  return out
end

local function unique_colors(colors)
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

local function push_if_distinct(out, hex, min_distance)
  min_distance = min_distance or 20
  for _, existing in ipairs(out) do
    if color_distance(existing, hex) < min_distance then
      return false
    end
  end
  out[#out + 1] = hex
  return true
end

local function push_if_varied(out, hex, min_distance, min_hue_distance)
  min_distance = min_distance or 20
  min_hue_distance = min_hue_distance or 22
  local has_hue = hue_degrees(hex) ~= nil
  for _, existing in ipairs(out) do
    if color_distance(existing, hex) < min_distance then
      return false
    end
    if has_hue and hue_degrees(existing) ~= nil and hue_distance(existing, hex) < min_hue_distance then
      return false
    end
  end
  out[#out + 1] = hex
  return true
end

local function kitty_ansi_palette(palette)
  local normal = {}
  local bright = {}

  local black_slot = palette.dark_mode and mix(palette.bg, palette.fg, 0.26) or mix(palette.bg, palette.fg, 0.68)
  local white_slot = palette.dark_mode and mix(palette.fg, palette.bg, 0.18) or mix(palette.fg, palette.bg, 0.30)

  normal[1] = lift_contrast(black_slot, palette.bg, 1.8, 0.18)
  normal[2] = lift_contrast(palette.accents[1], palette.bg, 2.8, 0.16)
  normal[3] = lift_contrast(palette.accents[2], palette.bg, 2.8, 0.16)
  normal[4] = lift_contrast(palette.accents[3], palette.bg, 2.8, 0.16)
  normal[5] = lift_contrast(palette.accents[4], palette.bg, 2.8, 0.16)
  normal[6] = lift_contrast(palette.accents[5], palette.bg, 2.8, 0.16)
  normal[7] = lift_contrast(palette.accents[6], palette.bg, 2.8, 0.16)
  normal[8] = ensure_contrast(white_slot, palette.bg, 4.5)

  bright[1] = lift_contrast(mix(normal[1], palette.fg, palette.dark_mode and 0.28 or 0.18), palette.bg, 2.4, 0.16)
  for i = 2, 7 do
    bright[i] = lift_contrast(mix(normal[i], palette.fg, palette.dark_mode and 0.22 or 0.14), palette.bg, 3.2, 0.16)
  end
  bright[8] = ensure_contrast(palette.fg, palette.bg, 7)

  return normal, bright
end

local function build_preview(bg, fg, accent, accents)
  local preview = { bg, fg, accent }
  for _, hex in ipairs(accents) do
    push_if_distinct(preview, hex, 8)
  end
  return preview
end

-- public

--- Build a full palette from dominant sampled colors.
function M.from_dominant_colors(dominant_colors)
  local sorted_by_luma = copy_table(unique_colors(dominant_colors))
  table.sort(sorted_by_luma, function(a, b)
    return luma(a) < luma(b)
  end)

  local median_color = sorted_by_luma[math.ceil(#sorted_by_luma / 2)]
  local wallpaper_is_dark = luma(median_color) < 140
  local contrast_theme = true
  local dark_mode = contrast_theme and not wallpaper_is_dark or wallpaper_is_dark

  local bg = dark_mode and sorted_by_luma[1] or sorted_by_luma[#sorted_by_luma]
  local fg_seed = dark_mode and sorted_by_luma[#sorted_by_luma] or sorted_by_luma[1]
  local fg = ensure_contrast(fg_seed, bg, 7)

  local bg_elevated = mix(bg, fg, dark_mode and 0.10 or 0.08)
  local bg_hover = mix(bg, fg, dark_mode and 0.15 or 0.12)
  local bg_active = mix(bg, fg, dark_mode and 0.22 or 0.18)
  local bg_border = mix(bg, fg, dark_mode and 0.28 or 0.24)
  local fg_muted = ensure_contrast(mix(fg, bg, 0.35), bg, 4.5)
  local fg_subtle = ensure_contrast(mix(fg, bg, 0.48), bg, 3.2)
  local fg_hover = ensure_contrast(mix(fg, bg, 0.14), bg, 6)
  local bg_shadow = dark_mode and "#101010" or "#bfb7af"
  local fg_shadow = dark_mode and "rgba(0, 0, 0, 0.377)" or bg

  local accent_candidates = {}
  for _, hex in ipairs(dominant_colors) do
    if color_distance(hex, bg) >= 28 and color_distance(hex, fg) >= 24 then
      accent_candidates[#accent_candidates + 1] = hex
    end
  end

  table.sort(accent_candidates, function(a, b)
    local score_a = chroma(a) * 1.6 + color_distance(a, bg) * 0.35 + math.min(contrast_ratio(a, bg), 6) * 14
    local score_b = chroma(b) * 1.6 + color_distance(b, bg) * 0.35 + math.min(contrast_ratio(b, bg), 6) * 14
    return score_a > score_b
  end)

  local accents = {}
  for _, hex in ipairs(accent_candidates) do
    if push_if_varied(accents, hex, 36, 28) and #accents >= 6 then
      break
    end
  end

  local accent_seed = accents[1] or sorted_by_luma[math.floor(#sorted_by_luma / 2)] or fg
  local accent = lift_contrast(accent_seed, bg, 2.6, 0.16)
  local accent_soft = lift_contrast(mix(accent, bg, 0.25), bg, 2.0, 0.16)
  local accent_strong = lift_contrast(mix(accent, fg, 0.25), bg, 3.0, 0.16)
  local accent_fg = ensure_contrast(best_text_on(accent), accent, 4.5)

  local fallback_accents = {
    accent,
    accent_strong,
    accent_soft,
    lift_contrast(mix(accent, fg, 0.45), bg, 2.4, 0.16),
    lift_contrast(mix(accent, bg, 0.45), bg, 1.8, 0.16),
    lift_contrast(mix(sorted_by_luma[#sorted_by_luma], bg, 0.35), bg, 3.0, 0.16),
  }

  for _, hex in ipairs(fallback_accents) do
    if #accents >= 6 then
      break
    end
    push_if_varied(accents, hex, 18, 12)
  end

  while #accents < 6 do
    accents[#accents + 1] = lift_contrast(mix(accent, fg, 0.12 * #accents), bg, 2.0, 0.16)
  end

  local palette = {
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
    accent_soft = accent_soft,
    accent_strong = accent_strong,
    accent_fg = accent_fg,
    accents = accents,
  }

  palette.kitty_normal, palette.kitty_bright = kitty_ansi_palette(palette)
  palette.preview = build_preview(bg, fg, accent, accents)

  return palette
end

return M
