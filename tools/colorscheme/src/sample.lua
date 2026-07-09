-- sample.lua
-- sampling main colors from a ppm data, deps on color_helper

local h = require("color_helper")
local luma = h.rgb_get_luma
local rgb_to_hex = h.rgb_to_hex
local clamp = h.clamp

local M = {}

-- definations

---@class SampleOptions
---@field samples? number
---@field topn? number
---@field qbits? number
---@field region? SampleRegion
---@field min_luma? number
---@field max_luma? number
---@field oversample_factor? number
local SampleOptions_default = {
	samples           = 12000,
	topn              = 16,
	qbits             = 5,
	region            = nil,
	min_luma          = nil,
	max_luma          = nil,
	oversample_factor = 10,
}

---@class SampleRegion
---@field x0 number
---@field y0 number
---@field x1 number
---@field y1 number

-- local helpers

---Quantisized color key
---@param r number 0-255
---@param g number 0-255
---@param b number 0-255
---@param qbits number 1-8
---@return number key 0..2^(3*qbits)-1
local function quant_key(r, g, b, qbits)
	local shift = 8 - qbits
	local rq = r >> shift
	local gq = g >> shift
	local bq = b >> shift
	return (rq << (2 * qbits)) | (gq << qbits) | bq
end

---Reproduce RGB from a quantized key.
---@param key number
---@param qbits number 1-8
---@return number r 0-255
---@return number g 0-255
---@return number b 0-255
local function repr_from_key(key, qbits)
	local mask = (1 << qbits) - 1
	local bq = key & mask
	local gq = (key >> qbits) & mask
	local rq = (key >> (2 * qbits)) & mask

	local shift = 8 - qbits
	local half = (shift > 0) and (1 << (shift - 1)) or 0
	local r = rq * (1 << shift) + half
	local g = gq * (1 << shift) + half
	local b = bq * (1 << shift) + half
	return clamp(r, 0, 255), clamp(g, 0, 255), clamp(b, 0, 255)
end

-- public

---Return the most common quantized colors from random samples.
---@param img table
---@param opts SampleOptions|nil
---@return string[] hex_colors
function M.top_colors(img, opts)
	opts             = opts or SampleOptions_default
	local samples    = opts.samples or SampleOptions_default.samples
	local topn       = opts.topn or SampleOptions_default.topn
	local qbits      = opts.qbits or SampleOptions_default.qbits
	local region     = opts.region
	local min_luma   = opts.min_luma
	local max_luma   = opts.max_luma
	local oversample = opts.oversample_factor or SampleOptions_default.oversample_factor

	if samples <= 0 then
		error("sample.top_colors: samples must be > 0")
	end
	if topn <= 0 then
		error("sample.top_colors: topn must be > 0")
	end
	if qbits < 1 or qbits > 8 then
		error("sample.top_colors: qbits must be 1..8")
	end

	local hist = {}
	local collected = 0
	local tries = 0
	local max_tries = samples * 4

	local function next_rgb()
		if region then
			return img:random_pixel_in(region.x0, region.y0, region.x1, region.y1)
		end
		return img:random_pixel()
	end

	while collected < samples and tries < max_tries do
		tries = tries + 1
		local r, g, b = next_rgb()
		local y = luma(r, g, b)
		if (not min_luma or y >= min_luma) and (not max_luma or y <= max_luma) then
			local k = quant_key(r, g, b, qbits)
			hist[k] = (hist[k] or 0) + 1
			collected = collected + 1
		end
	end

	if collected == 0 then
		return {}
	end

	local bins = {}
	for k, c in pairs(hist) do
		bins[#bins + 1] = { k = k, c = c }
	end
	table.sort(bins, function(a, b)
		return a.c > b.c
	end)

	local picked, seen = {}, {}
	local limit = math.min(#bins, topn * oversample)
	for i = 1, limit do
		local r, g, b = repr_from_key(bins[i].k, qbits)
		local hex = rgb_to_hex(r, g, b)
		if not seen[hex] then
			picked[#picked + 1] = hex
			seen[hex] = true
			if #picked >= topn then
				break
			end
		end
	end

	return picked
end

---Return a centered half-open sampling region.
---@param img PPM
---@param margin_ratio number|nil to be clamped from 0.0 to 0.49, default 0
---@return SampleRegion
function M.center_region(img, margin_ratio)
	margin_ratio = margin_ratio or 0
	margin_ratio = clamp(margin_ratio, 0, 0.49)
	local mx = math.floor(img.width * margin_ratio)
	local my = math.floor(img.height * margin_ratio)
	return { x0 = mx, y0 = my, x1 = img.width - mx, y1 = img.height - my }
end

return M
