# Color Schema Generator

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

3. Apply the generated files in your respective configuration files.