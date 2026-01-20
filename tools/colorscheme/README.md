# Color Scheme Generator

This tool generates color schemes from ppm (depends on `grim`), and outputs configuration files for `waybar`, `kitty` and so on.

## Usage

1. Run the script like this:
   ```bash
   grim -t ppm - | lua gen.lua
   ```
   or interactively select a region:
   ```bash
   grim -g "$(slurp)" -t ppm - | lua gen.lua
   ```
2. The script will output:
   - A waybar CSS file at `~/.config/waybar/colors.g.css`
   - A kitty color configuration at `~/.config/kitty/color.g.conf`
   - A rofi color .rasi file at `~/.config/rofi/colors.g.rasi`
   - Add a fullscreen rule in `~/.config/dunst/dunstrc`

3. Apply the generated files in your respective configuration files.

   See https://github.com/ToaaMusic/dotfiles/tree/main/config for exmaples