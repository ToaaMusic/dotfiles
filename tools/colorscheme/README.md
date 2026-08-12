# Color Scheme Generator

This tool reads a image (only PPM P6 format is supported for now), samples dominant colors, builds a unified color scheme, and serialize it to various configuration files.

## Usage

1. Run the script like this:

```bash
grim -t ppm - | lua gen.lua
```

or interactively select a region:

```bash
grim -g "$(slurp)" -t ppm - | lua gen.lua
```

2. The script will generate by default:

- A waybar CSS file at `~/.config/waybar/colors.g.css`
- A kitty color configuration at `~/.config/kitty/colors.g.conf`
- A cava theme at `~/.config/cava/themes/colors.g.theme`
- A rofi color .rasi file at `~/.config/rofi/colors.g.rasi`
- A generated fullscreen block in `~/.config/dunst/dunstrc`
- A Neovim palette module at `~/.config/nvim/lua/colors/g.lua`

3. Apply the generated files in your respective configuration files.

## Structure

- `gen.lua`: entrypoint, sampling orchestration, preview, notify, apply writes
- `src/ppm.lua`: P6 PPM parsing and random pixel access
- `src/sample.lua`: dominant color sampling and quantization
- `src/ColorScheme.lua`: ColorScheme class definition
- `src/write.lua`: write generated theme files for each target program
- `src/color_helper.lua`: shared color helpers
- `src/strategy.lua`: shared theme strategy helpers
- tpls/: templates for generated files
