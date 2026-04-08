# Color Scheme Generator

This tool reads a PPM image from stdin, samples dominant colors, builds a unified palette, and writes generated theme files for the desktop stack.

## Usage

1. Run the script like this:
   ```bash
   grim -t ppm - | lua gen.lua
   ```
   or interactively select a region:
   ```bash
   grim -g "$(slurp)" -t ppm - | lua gen.lua
   ```
2. The script will generate:
   - A waybar CSS file at `~/.config/waybar/colors.g.css`
   - A kitty color configuration at `~/.config/kitty/colors.g.conf`
   - A cava theme at `~/.config/cava/themes/colors.g.theme`
   - A rofi color .rasi file at `~/.config/rofi/colors.g.rasi`
   - A generated fullscreen block in `~/.config/dunst/dunstrc`
   - A Neovim palette module at `~/.config/nvim/lua/colors/g.lua`

3. Apply the generated files in your respective configuration files.

   See https://github.com/ToaaMusic/dotfiles/tree/main/config for examples.

## Structure

- `gen.lua`: entrypoint, sampling orchestration, preview, notify, apply writes
- `src/ppm.lua`: P6 PPM parsing and random pixel access
- `src/sample.lua`: dominant color sampling and quantization
- `src/colors.lua`: build the final palette from sampled colors
- `src/write.lua`: write generated theme files for each target program
- `src/helper.lua`: shared color and file helpers
