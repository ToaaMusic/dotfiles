-- bootstrap module path (relative to this script)
local script_dir = debug.getinfo(1, "S").source:sub(2):match("(.*/)")
package.path = script_dir .. "src/?.lua;" .. package.path

local helper = require("helper")
local colors = require("colors")
local sample = require("sample")
local ppm = require("ppm")
local write = require("write")
local hex_to_rgb = helper.hex_to_rgb
local send_notify = helper.send_notify

local img, err = ppm.from_stdin()
if not img then
  error(err)
end

ppm.seed_rng(img)

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
  error("not enough colors sampled from image")
end

local palette = colors.from_dominant_colors(dominant_colors)

local DOT = ""

local function ansi_reset()
  return "\27[0m"
end

local function ansi_fg_rgb(r, g, b)
  return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

local function preview_colors(colors)
  for _, hex in ipairs(colors) do
    local r, g, b = hex_to_rgb(hex)
    io.write(ansi_fg_rgb(r, g, b), DOT, " ")
  end
  io.write(ansi_reset(), "\n")

  for _, hex in ipairs(colors) do
    print(hex)
  end
end

preview_colors(palette.preview)
write.apply(palette)

-- send_notify(
--   "Color Scheme updated",
--   "waybar kitty cava rofi dunst nvim"
-- )
