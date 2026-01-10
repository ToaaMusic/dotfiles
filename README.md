# My Arch Linux / Hyprland Configuration

This repository contains my personal configuration files for Arch Linux with the Hyprland window manager. It includes settings for various applications and tools that I use regularly.

## Components

- **fastfetch**: System information tool.
- **hyprland**: Dynamic tiling window manager.
- **waybar**: Status bar for Wayland.
- **rofi**: Application launcher.
- **kitty**: Terminal emulator.
- **yazi**: File manager.
- **dunst** : Notification daemon.


## Installation
To use these configurations, clone the repository and copy the files to their respective locations in your home directory. Make sure to back up any existing configuration files before overwriting them.

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
# Copy files to ~/.config/* or run:
./link.sh
```

link.sh is a script that creates symbolic links from the repository to the appropriate configuration directories.

## Dependencies

Except the components, ensure you have the following packages installed on your system:

- `musicfox` <- waybar mpris
- `hyprpaper` <- wallpaper for hyprland