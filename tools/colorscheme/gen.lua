-- bootstrap module path (relative to this script)
local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

local ppm = require("ppm")
local sample = require("sample")
local colors = require("colors")
local write = require("write")

-- 1. Load Image from Stdin (PPM)
local img, err = ppm.from_stdin()
if not img then error(err) end

ppm.seed_rng(img)

-- 2. Sample dominant colors
local region = sample.center_region(img, 0.12)
local dominant_colors = sample.top_colors(img, {
  samples = 24000,
  topn = 16,
  qbits = 5,
  region = region,
  min_luma = 8,
  max_luma = 248,
})

if #dominant_colors < 4 then
  error("Not enough colors sampled from image")
end

-- 3. Generate Palette
local palette = colors.from_dominant_colors(dominant_colors)

-- 4. Output: Preview & Apply
write.preview(palette)
write.apply(palette)
