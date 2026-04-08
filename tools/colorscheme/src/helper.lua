local M = {}

-- [[ Internal ]]

local function srgb_to_linear(v)
  v = v / 255
  return v <= 0.04045 and v / 12.92 or ((v + 0.055) / 1.055) ^ 2.4
end

local function clamp(x)
  return math.max(0, math.min(255, x))
end

local function clamp01(x)
  return math.max(0, math.min(1, x))
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

--- Convert hex string to HSV components.
function M.hex_to_hsv(hex)
  local r, g, b = M.to_rgb(hex)
  r, g, b = r / 255, g / 255, b / 255
  local maxc, minc = math.max(r, g, b), math.min(r, g, b)
  local delta = maxc - minc

  local h = 0
  if delta ~= 0 then
    if maxc == r then h = ((g - b) / delta) % 6
    elseif maxc == g then h = ((b - r) / delta) + 2
    else h = ((r - g) / delta) + 4 end
    h = h * 60
  end

  local s = maxc == 0 and 0 or delta / maxc
  local v = maxc
  return h, s, v
end

--- Convert HSV components to hex string.
function M.hsv_to_hex(h, s, v)
  h = (h or 0) % 360
  s = clamp01(s or 0)
  v = clamp01(v or 0)

  local c = v * s
  local x = c * (1 - math.abs(((h / 60) % 2) - 1))
  local m = v - c

  local r1, g1, b1
  if h < 60 then r1, g1, b1 = c, x, 0
  elseif h < 120 then r1, g1, b1 = x, c, 0
  elseif h < 180 then r1, g1, b1 = 0, c, x
  elseif h < 240 then r1, g1, b1 = 0, x, c
  elseif h < 300 then r1, g1, b1 = x, 0, c
  else r1, g1, b1 = c, 0, x end

  return M.to_hex((r1 + m) * 255, (g1 + m) * 255, (b1 + m) * 255)
end

--- Rotate a color hue in HSV space.
function M.rotate_hue(hex, degrees, sat_floor, val_floor)
  local h, s, v = M.hex_to_hsv(hex)
  h = (h + (degrees or 0)) % 360
  if sat_floor then s = math.max(s, sat_floor) end
  if val_floor then v = math.max(v, val_floor) end
  return M.hsv_to_hex(h, s, v)
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
