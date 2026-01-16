-- sample.lua (chatgpt 5.2 generated and ToaaM. modified)
-- Sampling + quantization histogram for PPM pixels.
-- Depends on: ppm.lua
--
-- Usage pattern:
--   local ppm = require("ppm")
--   local sample = require("sample")
--   local img = assert(ppm.from_stdin())
--   ppm.seed_rng(img)
--   local colors = sample.top_colors(img, { samples=20000, topn=12 })

local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

local ppm = require("ppm")

local M = {}

-- ---------- quantization ----------
-- Default: 5 bits per channel => 32 levels each => 32768 bins
-- key layout: RRRRR GGGGG BBBBB in 15 bits
local function qbits_default()
  return 5
end

local function clamp(v, lo, hi)
  if v < lo then return lo end
  if v > hi then return hi end
  return v
end

local function quant_key(r, g, b, qbits)
  -- qbits: 1..8
  local shift = 8 - qbits
  local rq = r >> shift
  local gq = g >> shift
  local bq = b >> shift
  return (rq << (2 * qbits)) | (gq << qbits) | bq
end

local function repr_from_key(k, qbits)
  local mask = (1 << qbits) - 1
  local bq = k & mask
  local gq = (k >> qbits) & mask
  local rq = (k >> (2 * qbits)) & mask

  local shift = 8 - qbits
  -- center of the bin: q*2^shift + 2^(shift-1)
  local half = (shift > 0) and (1 << (shift - 1)) or 0
  local r = rq * (1 << shift) + half
  local g = gq * (1 << shift) + half
  local b = bq * (1 << shift) + half
  return clamp(r, 0, 255), clamp(g, 0, 255), clamp(b, 0, 255)
end

-- perceived luminance (approx), 0..255
local function luma(r, g, b)
  -- integer-friendly approximation of Rec.601:
  -- Y ≈ 0.299R + 0.587G + 0.114B
  return (299 * r + 587 * g + 114 * b) // 1000
end

-- ---------- options ----------
-- opts:
--   samples   (int)  number of random samples, default 12000
--   topn      (int)  number of colors to return, default 12
--   qbits     (int)  quantization bits per channel, default 5
--   region    (table) {x0,y0,x1,y1} 0-based, x1/y1 exclusive; default nil = full image
--   min_luma  (int)  filter out too dark pixels (<), default nil
--   max_luma  (int)  filter out too bright pixels (>), default nil
--   oversample_factor (number) try more bins than topn to dedup, default 10
--
-- returns:
--   { "#RRGGBB", ... }  length <= topn
function M.top_colors(img, opts)
  opts = opts or {}
  local samples = tonumber(opts.samples or "12000")
  local topn = tonumber(opts.topn or "12")
  local qbits = tonumber(opts.qbits or qbits_default())
  local region = opts.region
  local min_luma = opts.min_luma
  local max_luma = opts.max_luma
  local oversample = tonumber(opts.oversample_factor or "10")

  if samples <= 0 then error("sample.top_colors: samples must be > 0") end
  if topn <= 0 then error("sample.top_colors: topn must be > 0") end
  if qbits < 1 or qbits > 8 then error("sample.top_colors: qbits must be 1..8") end

  local hist = {}
  local collected = 0
  local tries = 0
  local max_tries = samples * 4 -- avoid infinite loops if filters too strict

  -- Sampling function
  local function next_rgb()
    if region then
      return ppm.random_pixel_in(img, region.x0, region.y0, region.x1, region.y1)
    else
      return ppm.random_pixel(img)
    end
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
  table.sort(bins, function(a, b) return a.c > b.c end)

  local picked, seen = {}, {}
  local limit = math.min(#bins, topn * oversample)
  for i = 1, limit do
    local r, g, b = repr_from_key(bins[i].k, qbits)
    local hex = ppm.rgb_to_hex(r, g, b)
    if not seen[hex] then
      picked[#picked + 1] = hex
      seen[hex] = true
      if #picked >= topn then break end
    end
  end

  return picked
end

-- Convenience: center region sampler (e.g. avoid bars/edges).
-- margin_ratio: 0..0.49 (e.g. 0.1 means ignore 10% border)
function M.center_region(img, margin_ratio)
  margin_ratio = tonumber(margin_ratio or "0.1")
  margin_ratio = clamp(margin_ratio, 0, 0.49)
  local mx = math.floor(img.width * margin_ratio)
  local my = math.floor(img.height * margin_ratio)
  return { x0 = mx, y0 = my, x1 = img.width - mx, y1 = img.height - my }
end

return M
