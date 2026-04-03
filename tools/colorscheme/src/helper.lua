--- normal
function _G.reverse_table(t)
  local r = {}
  for i = #t, 1, -1 do
    r[#r + 1] = t[i]
  end
  return r
end

--- notify send

function _G.send_notify(title, message)
  local command = string.format('notify-send "%s" "%s"', title, message)
  os.execute(command)
end

--- color helper

function _G.hex_to_rgb(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16),
         tonumber(hex:sub(3, 4), 16),
         tonumber(hex:sub(5, 6), 16)
end

function _G.rgb_to_hex(r, g, b)
  return string.format("#%02x%02x%02x", r, g, b)
end

--- 避免RGB数值溢出
function _G.clamp(x) return math.max(0, math.min(255, x)) end

--- 计算感知亮度
function _G.luma(hex)
  local r, g, b = hex_to_rgb(hex)
  -- perceptual-ish luma
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

--- RGB整体加减,+浅-深
--- delta: -255..255
function _G.adjust(hex, delta)
  local r, g, b = hex_to_rgb(hex)
  return rgb_to_hex(clamp(r + delta), clamp(g + delta), clamp(b + delta))
end

function _G.mix(hex1, hex2, t)
  t = math.max(0, math.min(1, t or 0.5))
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  return rgb_to_hex(
    math.floor(r1 + (r2 - r1) * t + 0.5),
    math.floor(g1 + (g2 - g1) * t + 0.5),
    math.floor(b1 + (b2 - b1) * t + 0.5)
  )
end

function _G.chroma(hex)
  local r, g, b = hex_to_rgb(hex)
  return math.max(r, g, b) - math.min(r, g, b)
end

function _G.color_distance(hex1, hex2)
  local r1, g1, b1 = hex_to_rgb(hex1)
  local r2, g2, b2 = hex_to_rgb(hex2)
  local dr = r1 - r2
  local dg = g1 - g2
  local db = b1 - b2
  return math.sqrt(dr * dr + dg * dg + db * db)
end

function _G.hue_degrees(hex)
  local r, g, b = hex_to_rgb(hex)
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

function _G.hue_distance(hex1, hex2)
  local h1 = hue_degrees(hex1)
  local h2 = hue_degrees(hex2)
  if not h1 or not h2 then
    return 0
  end
  local diff = math.abs(h1 - h2)
  return math.min(diff, 360 - diff)
end

local function srgb_to_linear(v)
  v = v / 255
  if v <= 0.04045 then
    return v / 12.92
  end
  return ((v + 0.055) / 1.055) ^ 2.4
end

function _G.rel_luminance(hex)
  local r, g, b = hex_to_rgb(hex)
  local rl = srgb_to_linear(r)
  local gl = srgb_to_linear(g)
  local bl = srgb_to_linear(b)
  return 0.2126 * rl + 0.7152 * gl + 0.0722 * bl
end

function _G.contrast_ratio(hex1, hex2)
  local l1 = rel_luminance(hex1)
  local l2 = rel_luminance(hex2)
  local hi = math.max(l1, l2)
  local lo = math.min(l1, l2)
  return (hi + 0.05) / (lo + 0.05)
end

function _G.best_text_on(bg)
  local black = "#000000"
  local white = "#ffffff"
  if contrast_ratio(black, bg) >= contrast_ratio(white, bg) then
    return black
  end
  return white
end

function _G.ensure_contrast(fg, bg, min_ratio)
  min_ratio = min_ratio or 4.5
  if contrast_ratio(fg, bg) >= min_ratio then
    return fg
  end

  local fallback = best_text_on(bg)
  if contrast_ratio(fallback, bg) >= min_ratio then
    return fallback
  end

  local target = fallback == "#ffffff" and "#ffffff" or "#000000"
  local current = fg
  for _ = 1, 8 do
    current = mix(current, target, 0.35)
    if contrast_ratio(current, bg) >= min_ratio then
      return current
    end
  end

  return fallback
end

function _G.lift_contrast(hex, bg, min_ratio, step)
  min_ratio = min_ratio or 3
  step = step or 0.18
  if contrast_ratio(hex, bg) >= min_ratio then
    return hex
  end

  local current = hex
  local target = best_text_on(bg)
  for _ = 1, 12 do
    current = mix(current, target, step)
    if contrast_ratio(current, bg) >= min_ratio then
      return current
    end
  end

  return current
end


--- file writing helper

function _G.upsert_generated_block(
  path,
  new_content,
  comment_symbol,  -- 可选，默认 "//"
  marker           -- 可选，默认 "generated"
)
  comment_symbol = comment_symbol or "//"
  marker = marker or "generated"

  -- 读原文件（不存在则视为空）
  local text = ""
  do
    local rf = io.open(path, "r")
    if rf then
      text = rf:read("*a")
      rf:close()
    end
  end

  local function esc(s)
    return s:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  end

  local cs = esc(comment_symbol)
  local mk = esc(marker)

  local start_pat = cs .. "%s*" .. mk .. "%s*\n"
  local end_pat   = cs .. "%s*" .. mk .. "%s*end%s*\n?"

  local s, e = text:find(start_pat)
  local s2, e2

  if s then
    s2, e2 = text:find(end_pat, e + 1)
    if not s2 then
      error("found start marker but missing end marker")
    end

    local before = text:sub(1, s - 1)
    local after  = text:sub(e2 + 1)

    text =
      before ..
      comment_symbol .. " " .. marker .. "\n" ..
      new_content .. "\n" ..
      comment_symbol .. " " .. marker .. " end\n" ..
      after
  else
    -- 末尾追加
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
