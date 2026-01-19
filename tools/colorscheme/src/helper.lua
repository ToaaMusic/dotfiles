--normal
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

-- color helper

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


-- file writing helper

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
