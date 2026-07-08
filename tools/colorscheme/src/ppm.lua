-- colorscheme/src/ppm.lua

local Factory = {}

-- internal

---@param b number byte value
---@return boolean is_space
local function is_space(b)
	return b == 32 or b == 9 or b == 10 or b == 13 or b == 12
end

---@param s string
---@param i integer start index
---@return integer next_i next index
local function skip_ws_and_comments(s, i)
	local n = #s
	while i <= n do
		local b = s:byte(i)
		if is_space(b) then
			i = i + 1
		elseif b == 35 then
			while i <= n and s:byte(i) ~= 10 do
				i = i + 1
			end
		else
			break
		end
	end
	return i
end

---@param s string
---@param i integer
---@return string|nil token
---@return integer next_i
local function read_token(s, i)
	i = skip_ws_and_comments(s, i)
	local n = #s
	local j = i
	while j <= n do
		local b = s:byte(j)
		if not b or is_space(b) then
			break
		end
		j = j + 1
	end
	if j == i then return nil, i end
	return s:sub(i, j - 1), j
end

---Skip single whitespace byte after header (PPM requires exactly one whitespace before pixel data).
---@param s string
---@param i integer
---@return integer|nil next_i
---@return string|nil error
local function skip_single_ppm_separator(s, i)
	local b = s:byte(i)
	if not b then
		return nil, "ppm.parse: missing pixel separator"
	end
	if not is_space(b) then
		return nil, "ppm.parse: missing whitespace before pixel data"
	end
	return i + 1
end

---Read file as binary.
---@param path string
---@return string|nil data
---@return string|nil error
local function read_all_file(path)
	local f, err = io.open(path, "rb")
	if not f then return nil, err end
	local data = f:read("*a")
	f:close()
	return data
end

-- def

---@class PPM
---@field data string
---@field width number
---@field height number
---@field maxval number
---@field pixel_start number
---@field pixel_bytes number
---@field get_pixel fun(self:PPM, x:number, y:number): number, number, number
---@field random_pixel_in fun(self:PPM, x0:number, y0:number, x1:number, y1:number): number, number, number
---@field random_pixel fun(self:PPM): number, number, number
---@field random_index fun(self:PPM): number
---@field seed_rng fun(self:PPM)
---@field get_pixel_by_index fun(self:PPM, idx:number):number, number, number
local PPM = {}
PPM.__index = PPM

-- public

---Parse P6 PPM data from a raw string.
---@param raw string raw PPM content
---@return PPM|nil ppm
---@return string|nil error
function Factory.parse(raw)
	if type(raw) ~= "string" or #raw == 0 then
		return nil, "ppm.parse: empty input"
	end

	local i = 1 -- postion

	-- check magic
	local magic; magic, i = read_token(raw, i)
	if magic ~= "P6" then
		return nil, ("ppm.parse: not P6 (magic=%s)"):format(tostring(magic))
	end

	-- width, height and maxv
	local w_s; w_s, i = read_token(raw, i)
	local h_s; h_s, i = read_token(raw, i)
	local m_s; m_s, i = read_token(raw, i)

	local w = tonumber(w_s)
	local h = tonumber(h_s)
	local maxv = tonumber(m_s)

	-- check
	if not w or not h or not maxv then
		return nil, "ppm.parse: invalid header tokens"
	end
	if w <= 0 or h <= 0 then
		return nil, ("ppm.parse: invalid dimensions %dx%d"):format(w, h)
	end
	if maxv ~= 255 then
		return nil, ("ppm.parse: only maxval=255 supported (got %d)"):format(maxv)
	end

	-- handle separator
	local i_temp, sep_err = skip_single_ppm_separator(raw, i)
	if not i_temp then
		return nil, sep_err
	end
	i = i_temp

	-- byte start and length
	local pixel_start = i
	local pixel_bytes = w * h * 3

	-- check length
	local available = #raw - pixel_start + 1
	if available < pixel_bytes then
		return nil, ("ppm.parse: pixel data too short (need %d, got %d)"):format(pixel_bytes, available)
	end

	return setmetatable({
		data = raw,
		width = w,
		height = h,
		maxval = maxv,
		pixel_start = pixel_start,
		pixel_bytes = pixel_bytes,
	}, PPM), nil
end

---Read and parse P6 PPM from stdin.
---@return PPM|nil ppm
---@return string|nil error
function Factory.from_stdin()
	local data = io.stdin:read("*a")
	return Factory.parse(data)
end

---Read and parse P6 PPM from a file.
---@return PPM|nil ppm
---@return string|nil error
function Factory.from_file(path)
	local data, err = read_all_file(path)
	if not data then return nil, ("ppm.from_file: %s"):format(err or "read failed") end
	return Factory.parse(data)
end

--- Get pixel RGB by absolute index.
function PPM:get_pixel_by_index(idx)
	local w, h = self.width, self.height
	local total = w * h
	if idx < 0 or idx >= total then
		error(("ppm.get_pixel_by_index: idx out of range (%d, total=%d)"):format(idx, total))
	end
	local p = self.pixel_start + idx * 3
	local d = self.data
	return d:byte(p), d:byte(p + 1), d:byte(p + 2)
end

--- Get pixel RGB by 0-based coordinates.
function PPM:get_pixel(x, y)
	if x < 0 or x >= self.width or y < 0 or y >= self.height then
		error(("ppm.get_pixel: out of range (%d,%d) in %dx%d"):format(x, y, self.width, self.height))
	end
	local idx = y * self.width + x
	return self:get_pixel_by_index(idx)
end

--- Seed RNG for sampling.
function PPM:seed_rng()
	math.randomseed(os.time() ~ self.width ~ (self.height << 16))
end

--- Sample a random pixel index.
function PPM:random_index()
	local total = self.width * self.height
	return math.random(0, total - 1)
end

--- Sample a random pixel RGB.
function PPM:random_pixel()
	local idx = self:random_index()
	return self:get_pixel_by_index(idx)
end

--- Sample a random pixel within a 0-based half-open region.
function PPM:random_pixel_in(x0, y0, x1, y1)
	if x0 < 0 then x0 = 0 end
	if y0 < 0 then y0 = 0 end
	if x1 > self.width then x1 = self.width end
	if y1 > self.height then y1 = self.height end
	if x1 <= x0 or y1 <= y0 then
		error("ppm.random_pixel_in: empty region")
	end
	local x = math.random(x0, x1 - 1)
	local y = math.random(y0, y1 - 1)
	return self:get_pixel(x, y)
end

return Factory
