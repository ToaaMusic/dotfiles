local M = {}

-- [[ Internal ]]

local function srgb_to_linear(v)
  v = v / 255
  return v <= 0.04045 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
end

local function clamp(x)
  return math.max(0, math.min(255, x))
end

-- [[ Conversion ]]

--- Convert hex string to RGB.
function M.to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16),
         tonumber(hex:sub(3, 4), 16),
         tonumber(hex:sub(5, 6), 16)
end

--- Convert RGB components to hex string.
function M.to_hex(r, g, b)
  return string.format("#%02x%02x%02x", math.floor(clamp(r)), math.floor(clamp(g)), math.floor(clamp(b)))
end


-- [[ Properties ]]

--- Perceptual luma (0-255).
function M.get_luma(hex)
  local r, g, b = M.to_rgb(hex)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- Relative luminance for WCAG (0.0-1.0).
function M.get_luminance(hex)
  local r, g, b = M.to_rgb(hex)
  return 0.2126 * srgb_to_linear(r) + 0.7152 * srgb_to_linear(g) + 0.0722 * srgb_to_linear(b)
end

--- Color chroma/saturation.
function M.get_chroma(hex)
  local r, g, b = M.to_rgb(hex)
  return math.max(r, g, b) - math.min(r, g, b)
end

--- Hue in degrees (0-360) or nil.
function M.get_hue(hex)
  local r, g, b = M.to_rgb(hex)
  r, g, b = r / 255, g / 255, b / 255
  local maxc, minc = math.max(r, g, b), math.min(r, g, b)
  local delta = maxc - minc
  if delta == 0 then return nil end

  local hue
  if maxc == r then hue = ((g - b) / delta) % 6
  elseif maxc == g then hue = ((b - r) / delta) + 2
  else hue = ((r - g) / delta) + 4 end
  return hue * 60
end

-- [[ Comparison ]]

--- Euclidean RGB distance.
function M.get_distance(hex1, hex2)
  local r1, g1, b1 = M.to_rgb(hex1)
  local r2, g2, b2 = M.to_rgb(hex2)
  return math.sqrt((r1 - r2) ^ 2 + (g1 - g2) ^ 2 + (b1 - b2) ^ 2)
end

--- WCAG contrast ratio.
function M.get_contrast(hex1, hex2)
  local l1 = M.get_luminance(hex1)
  local l2 = M.get_luminance(hex2)
  return (math.max(l1, l2) + 0.05) / (math.min(l1, l2) + 0.05)
end

--- Wrapped hue distance (0-180).
function M.get_hue_distance(hex1, hex2)
  local h1, h2 = M.get_hue(hex1), M.get_hue(hex2)
  if not h1 or not h2 then return 0 end
  local diff = math.abs(h1 - h2)
  return math.min(diff, 360 - diff)
end

-- [[ Manipulation ]]

--- Mix two colors (ratio 0.0-1.0).
function M.mix(hex1, hex2, ratio)
  ratio = ratio or 0.5
  local r1, g1, b1 = M.to_rgb(hex1)
  local r2, g2, b2 = M.to_rgb(hex2)
  return M.to_hex(
    r1 + (r2 - r1) * ratio + 0.5,
    g1 + (g2 - g1) * ratio + 0.5,
    b1 + (b2 - b1) * ratio + 0.5
  )
end

return M
