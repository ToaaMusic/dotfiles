# My Arch Linux / Hyprland Configuration

This repository contains my personal configuration files for Arch Linux with the Hyprland window manager. It includes settings for various applications and tools that I use regularly.

## Components

- **`fastfetch`**: System information tool.
- **`hyprland`**: Dynamic tiling window manager.
- **`hyprpaper`** Wallpaper manager of hyprland.
- **`waybar`**: Status bar for Wayland.
- **`rofi`**: Application launcher.
- **`kitty`**: Terminal emulator.
- **`yazi`**: File manager.
- **`dunst`**: Notification daemon.
- **`cava`**: Audio Visualizer.


## Installation
To use these configurations, clone the repository to a location you like, for example `~/repos`, and copy the files in `~/repos/dotfiles/config/*` to `~/.config/*`. Make sure to back up any existing configuration files before overwriting them.

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
# Copy files to ~/.config/* or run:
./link.sh
```

`link.sh` is a script that creates symbolic links from the repository to the appropriate configuration directories.

```bash
~/.config   symlink    ~/repos/dotfiles/config
├── hypr   --------->  ├── hypr
├── waybar --------->  ├── waybar
├── rofi   --------->  ├── rofi
├── kitty  --------->  ├── kitty
└── ...                      └── ...
```

## Dependencies

- `musicfox` <- waybar mpris
- `mpvpaper` <- Dynamic wallpaper.
- `grim`, `slurp`, `wl-copy` <- Screenshot, Selection, and copy to clipboard
- `lua` ~ tool language

After installing the key components, if you want the full experience or just prefer not to customize everything, you can simply install them all.

```bash
sudo pacman -S kitty hyprland hyprpaper waybar fastfetch rofi dunst cava yazi
```

```bash
sudo pacman -S musicfox grim slurp wl-copy mpvpaper lua
```
