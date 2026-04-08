local M = {}

-- internal

local function srgb_to_linear(v)
  v = v / 255
  if v <= 0.04045 then
    return v / 12.92
  end
  return ((v + 0.055) / 1.055) ^ 2.4
end

local function escape_pattern(s)
  return s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
end

-- public

--- Send a desktop notification.
function M.send_notify(title, message)
  local command = string.format('notify-send "%s" "%s"', title, message)
  os.execute(command)
end

--- Convert a hex color to RGB.
function M.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16),
         tonumber(hex:sub(3, 4), 16),
         tonumber(hex:sub(5, 6), 16)
end

--- Convert RGB to a hex color.
function M.rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

--- Clamp a channel value to 0..255.
function M.clamp(x)
  return math.max(0, math.min(255, x))
end

--- Return perceptual luma for a hex color.
function M.luma(hex)
  local r, g, b = M.hex_to_rgb(hex)
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- Mix two hex colors by ratio t.
function M.mix(hex1, hex2, t)
  t = math.max(0, math.min(1, t or 0.5))
  local r1, g1, b1 = M.hex_to_rgb(hex1)
  local r2, g2, b2 = M.hex_to_rgb(hex2)
  return M.rgb_to_hex(
    math.floor(r1 + (r2 - r1) * t + 0.5),
    math.floor(g1 + (g2 - g1) * t + 0.5),
    math.floor(b1 + (b2 - b1) * t + 0.5)
  )
end

--- Return RGB chroma for a hex color.
function M.chroma(hex)
  local r, g, b = M.hex_to_rgb(hex)
  return math.max(r, g, b) - math.min(r, g, b)
end

--- Return Euclidean RGB distance between two hex colors.
function M.color_distance(hex1, hex2)
  local r1, g1, b1 = M.hex_to_rgb(hex1)
  local r2, g2, b2 = M.hex_to_rgb(hex2)
  local dr = r1 - r2
  local dg = g1 - g2
  local db = b1 - b2
  return math.sqrt(dr * dr + dg * dg + db * db)
end

--- Return hue in degrees, or nil for grayscale colors.
function M.hue_degrees(hex)
  local r, g, b = M.hex_to_rgb(hex)
  r = r / 255
  g = g / 255
  b = b / 255

  local maxc = math.max(r, g, b)
  local minc = math.min(r, g, b)
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

--- Return wrapped hue distance in degrees.
function M.hue_distance(hex1, hex2)
  local h1 = M.hue_degrees(hex1)
  local h2 = M.hue_degrees(hex2)
  if not h1 or not h2 then
    return 0
  end
  local diff = math.abs(h1 - h2)
  return math.min(diff, 360 - diff)
end

--- Return WCAG relative luminance for a hex color.
function M.rel_luminance(hex)
  local r, g, b = M.hex_to_rgb(hex)
  local rl = srgb_to_linear(r)
  local gl = srgb_to_linear(g)
  local bl = srgb_to_linear(b)
  return 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
end

--- Return WCAG contrast ratio between two hex colors.
function M.contrast_ratio(hex1, hex2)
  local l1 = M.rel_luminance(hex1)
  local l2 = M.rel_luminance(hex2)
  local hi = math.max(l1, l2)
  local lo = math.min(l1, l2)
  return (hi + 0.05) / (lo + 0.05)
end

--- Return black or white text for a background.
function M.best_text_on(bg)
  local black = "#000000"
  local white = "#ffffff"
  if M.contrast_ratio(black, bg) >= M.contrast_ratio(white, bg) then
    return black
  end
  return white
end

--- Raise foreground contrast against a background.
function M.ensure_contrast(fg, bg, min_ratio)
  min_ratio = min_ratio or 4.5
  if M.contrast_ratio(fg, bg) >= min_ratio then
    return fg
  end

  local fallback = M.best_text_on(bg)
  if M.contrast_ratio(fallback, bg) >= min_ratio then
    return fallback
  end

  local target = fallback
  local current = fg
  for _ = 1, 8 do
    current = M.mix(current, target, 0.35)
    if M.contrast_ratio(current, bg) >= min_ratio then
      return current
    end
  end

  return fallback
end

--- Push a color toward readable contrast against a background.
function M.lift_contrast(hex, bg, min_ratio, step)
  min_ratio = min_ratio or 3
  step = step or 0.18
  if M.contrast_ratio(hex, bg) >= min_ratio then
    return hex
  end

  local current = hex
  local target = M.best_text_on(bg)
  for _ = 1, 12 do
    current = M.mix(current, target, step)
    if M.contrast_ratio(current, bg) >= min_ratio then
      return current
    end
  end

  return current
end

--- Replace or append a marked generated block in a file.
function M.upsert_generated_block(path, new_content, comment_symbol, marker)
  comment_symbol = comment_symbol or "//"
  marker = marker or "generated"

  local text = ""
  local rf = io.open(path, "r")
  if rf then
    text = rf:read("*a")
    rf:close()
  end

  local cs = escape_pattern(comment_symbol)
  local mk = escape_pattern(marker)
  local start_pat = cs .. "%s*" .. mk .. "%s*\n"
  local end_pat = cs .. "%s*" .. mk .. "%s*end%s*\n?"
  local s, e = text:find(start_pat)

  if s then
    local s2, e2 = text:find(end_pat, e + 1)
    if not s2 then
      error("found start marker but missing end marker")
    end
    text =
      text:sub(1, s - 1) ..
      comment_symbol .. " " .. marker .. "\n" ..
      new_content .. "\n" ..
      comment_symbol .. " " .. marker .. " end\n" ..
      text:sub(e2 + 1)
  else
    if text ~= "" and not text:match("\n$") then
      text = text .. "\n"
    end
    text =
      text ..
      "\n" ..
      comment_symbol .. " " .. marker .. "\n" ..
      new_content .. "\n" ..
      comment_symbol .. " " .. marker .. " end\n"
  end

  local wf = assert(io.open(path, "w"))
  wf:write(text)
  wf:close()
end

return M
