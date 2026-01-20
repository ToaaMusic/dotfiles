# My Arch Linux + Hyprland Configuration

This repository contains my personal configuration files for Arch Linux with the Hyprland window manager. It includes settings for various applications and tools that I use regularly.


### Components

| Component | Description | Official Doc | Repository Folder |
|---|---|---|---|
| **hyprland** | Wayland compositor | https://wiki.hyprland.org/ | [hypr](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr) |
| **fastfetch** | System info fetcher | https://github.com/fastfetch-cli/fastfetch | [fastfetch](https://github.com/ToaaMusic/dotfiles/tree/main/config/fastfetch) |
| **waybar** | Status bar | https://github.com/Alexays/Waybar/wiki | [waybar](https://github.com/ToaaMusic/dotfiles/tree/main/config/waybar) |
| **rofi** | App launcher | https://github.com/davatorium/rofi | [rofi](https://github.com/ToaaMusic/dotfiles/tree/main/config/rofi) |
| **kitty** | Terminal | https://sw.kovidgoyal.net/kitty/ | [kitty](https://github.com/ToaaMusic/dotfiles/tree/main/config/kitty) |
| **yazi** | Tui file manager | https://yazi-rs.github.io/ | [yazi](https://github.com/ToaaMusic/dotfiles/tree/main/config/yazi) |
| **dunst** | Notification | https://dunst-project.org/ | [dunst](https://github.com/ToaaMusic/dotfiles/tree/main/config/dunst) |
| **cava** | Tui audio visualizer | https://github.com/karlstav/cava | [cava](https://github.com/ToaaMusic/dotfiles/tree/main/config/cava) |



## Installation
To copy my configurations, clone the repository to a safe location you like, for example `~/repos`, and copy the files in `~/repos/dotfiles/config/*` to `~/.config/*`. **Make sure to back up any existing configuration files before overwriting them.**

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
# Copy files to ~/.config/* or run:
./link.sh
```

`link.sh` is a script that creates symbolic links from the repository to the appropriate configuration directories.

Like this:

```bash
~/.config  symlink to  ~/repos/dotfiles/config
├── hypr   --------->  ├── hypr
├── waybar --------->  ├── waybar
├── rofi   --------->  ├── rofi
├── kitty  --------->  ├── kitty
└── ...                      └── ...
```

## Dependencies
- `hyprpaper` <- wallpaper.
- `mpvpaper` <- Dynamic wallpaper. (optional)
- `lua` ~ Tool language. (IMPORTANT)
- `grim`, `slurp`, `wl-copy` <- Screenshot, Selection, and copy to clipboard
- `ffmpeg` ~ img transportor.

After installing the key components, if you want the full experience or just lazy to customize everything, you can simply install them all.

```bash
sudo pacman -S kitty hyprland hyprpaper waybar fastfetch rofi dunst cava yazi
```

```bash
sudo pacman -S musicfox grim slurp wl-copy mpvpaper lua ffmpeg
```

## Usage

### Shortcuts

See markdown in [config/hypr/](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr/) for more.


| Default            | Action                                   |
|--------------------|------------------------------------------|
| `ALT + C`          | Close active window                      |
| `ALT + M`          | Exit hyprland                            |
| `ALT + V`          | Toggle floating mode for                 |
| `ALT + Q`          | Open Terminal                            |
| `ALT + 1~9`        | Switch workspace                         |
| `ALT + SHIFT + 1~9`| Move window to target workspace          |
| `F11`              | Toggle fullsceen                         |
|``||

| Custom             | Action                                   |
|--------------------|------------------------------------------|
| `ALT + F`          | Open File Manager (yazi)                 |
| `ALT + Z`          | Open musicfox                            |
| `ALT + A`          | Open rofi                                |
| `ALT + E`          | Open edge                                |
| `ALT + W`          | Set a random wallpaper                   |
| `ALT + SHIFT + W`  | Set a random Dynimic wallpaper           |
| `ALT + R`          | Refresh display                          |
| `ALT + H`          | Toggle bar layout                        |
| `ALT + B`          | Generate and apply colors from fullscreen|
| `ALT + SHIFT + B`  | ~ from a screen selection                |
| `PrtSc`            | Grab screen to clipboard                 |
|``||    

### Tools

See [tools/](https://github.com/ToaaMusic/dotfiles/tree/main/tools/) for more.

* **colorscheme/**

    Give `gen.lua` a **ppm** input an it will output `*.g.*` to `./config/*/`, then those components will apply the color scheme by themselves.

    ```bash
    grim -t ppm - | lua gen.lua
    ```  
    or
    ```bash
    ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua gen.lua
    ```