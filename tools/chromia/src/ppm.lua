-- lua/ppm.lua
-- PPM (P6) parser for Lua 5.4
-- Supports:
--   - Read from stdin/file/string (binary)
--   - Parse header with comments (# ...)
--   - Provide pixel offset, width/height, and fast pixel access
--
-- Notes:
--   - Only supports maxval = 255 (8-bit per channel), which is what grim outputs.
--   - Data layout after header: RGBRGBRGB... (row-major)

local M = {}

-- ---------- internal helpers ----------
local function is_space(b)
  return b == 32 or b == 9 or b == 10 or b == 13 or b == 12 -- space \t \n \r \f
end

local function skip_ws_and_comments(s, i)
  local n = #s
  while i <= n do
    local b = s:byte(i)
    if is_space(b) then
      i = i + 1
    elseif b == 35 then -- '#'
      -- skip comment until newline
      while i <= n and s:byte(i) ~= 10 do
        i = i + 1
      end
    else
      break
    end
  end
  return i
end

local function read_token(s, i)
  i = skip_ws_and_comments(s, i)
  local n = #s
  local j = i
  while j <= n and not is_space(s:byte(j)) do
    j = j + 1
  end
  if j == i then return nil, i end
  return s:sub(i, j - 1), j
end

local function read_all_file(path)
  local f, err = io.open(path, "rb")
  if not f then return nil, err end
  local data = f:read("*a")
  f:close()
  return data
end

-- ---------- public API ----------

--- Parse PPM(P6) binary data from a string.
--- @param data string
--- @return table ppm  { data, width, height, maxval, pixel_start, pixel_bytes }
--- @return string|nil err
function M.parse(data)
  if type(data) ~= "string" or #data == 0 then
    return nil, "ppm.parse: empty input"
  end

  local i = 1
  local magic; magic, i = read_token(data, i)
  if magic ~= "P6" then
    return nil, ("ppm.parse: not P6 (magic=%s)"):format(tostring(magic))
  end

  local w_s; w_s, i = read_token(data, i)
  local h_s; h_s, i = read_token(data, i)
  local m_s; m_s, i = read_token(data, i)

  local w = tonumber(w_s)
  local h = tonumber(h_s)
  local maxv = tonumber(m_s)

  if not w or not h or not maxv then
    return nil, "ppm.parse: invalid header tokens"
  end
  if w <= 0 or h <= 0 then
    return nil, ("ppm.parse: invalid dimensions %dx%d"):format(w, h)
  end
  if maxv ~= 255 then
    return nil, ("ppm.parse: only maxval=255 supported (got %d)"):format(maxv)
  end

  -- Skip trailing whitespace/comments before pixel bytes
  i = skip_ws_and_comments(data, i)
  local pixel_start = i

  local pixel_bytes = w * h * 3
  local available = #data - pixel_start + 1
  if available < pixel_bytes then
    return nil, ("ppm.parse: pixel data too short (need %d, got %d)"):format(pixel_bytes, available)
  end

  return {
    data = data,
    width = w,
    height = h,
    maxval = maxv,
    pixel_start = pixel_start,
    pixel_bytes = pixel_bytes,
  }, nil
end

--- Read and parse PPM(P6) from stdin.
--- @return table|nil ppm
--- @return string|nil err
function M.from_stdin()
  local data = io.stdin:read("*a")
  return M.parse(data)
end

--- Read and parse PPM(P6) from a file.
--- @param path string
--- @return table|nil ppm
--- @return string|nil err
function M.from_file(path)
  local data, err = read_all_file(path)
  if not data then return nil, ("ppm.from_file: %s"):format(err or "read failed") end
  return M.parse(data)
end

--- Get pixel RGB by absolute pixel index (0..w*h-1).
--- @param ppm table
--- @param idx integer
--- @return integer r,g,b
function M.get_pixel_by_index(ppm, idx)
  local w, h = ppm.width, ppm.height
  local total = w * h
  if idx < 0 or idx >= total then
    error(("ppm.get_pixel_by_index: idx out of range (%d, total=%d)"):format(idx, total))
  end
  local p = ppm.pixel_start + idx * 3
  local d = ppm.data
  return d:byte(p), d:byte(p + 1), d:byte(p + 2)
end

--- Get pixel RGB by x,y (0-based).
--- @param ppm table
--- @param x integer
--- @param y integer
--- @return integer r,g,b
function M.get_pixel(ppm, x, y)
  if x < 0 or x >= ppm.width or y < 0 or y >= ppm.height then
    error(("ppm.get_pixel: out of range (%d,%d) in %dx%d"):format(x, y, ppm.width, ppm.height))
  end
  local idx = y * ppm.width + x
  return M.get_pixel_by_index(ppm, idx)
end

--- Convert RGB to hex string "#RRGGBB".
function M.rgb_to_hex(r, g, b)
  return string.format("#%02X%02X%02X", r, g, b)
end

--- Seed RNG with some entropy related to image size.
function M.seed_rng(ppm)
  -- Lua 5.4: bitwise ops available
  math.randomseed(os.time() ~ (ppm.width * 1315423911) ~ (ppm.height * 2654435761))
end

--- Sample a random pixel index.
--- @param ppm table
--- @return integer idx
function M.random_index(ppm)
  local total = ppm.width * ppm.height
  return math.random(0, total - 1)
end

--- Sample a random pixel's RGB.
--- @param ppm table
--- @return integer r,g,b
function M.random_pixel(ppm)
  local idx = M.random_index(ppm)
  return M.get_pixel_by_index(ppm, idx)
end

--- Sample a random pixel within a rectangle region (0-based, inclusive start, exclusive end).
--- Useful to avoid top bars or edges (e.g., sample center area).
--- @param ppm table
--- @param x0 integer
--- @param y0 integer
--- @param x1 integer
--- @param y1 integer
--- @return integer r,g,b
function M.random_pixel_in(ppm, x0, y0, x1, y1)
  if x0 < 0 then x0 = 0 end
  if y0 < 0 then y0 = 0 end
  if x1 > ppm.width then x1 = ppm.width end
  if y1 > ppm.height then y1 = ppm.height end
  if x1 <= x0 or y1 <= y0 then
    error("ppm.random_pixel_in: empty region")
  end
  local x = math.random(x0, x1 - 1)
  local y = math.random(y0, y1 - 1)
  return M.get_pixel(ppm, x, y)
end

return M
