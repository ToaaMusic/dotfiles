# My Arch Linux Configuration

[简体中文](./README.zh-CN.md)

This repository contains my personal configuration for Arch Linux and some tools written by lua script.

## ✨ Components

| Component | Description | Official Doc | Repository Folder |
|---|---|---|---|
| **hyprland** | Wayland compositor | https://wiki.hyprland.org/ | [hypr](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr) |
| **nvim** | Text editor | https://neovim.io/ | [nvim](https://github.com/ToaaMusic/dotfiles/tree/main/config/nvim) |
| **fastfetch** | System info fetcher | https://github.com/fastfetch-cli/fastfetch | [fastfetch](https://github.com/ToaaMusic/dotfiles/tree/main/config/fastfetch) |
| **waybar** | Status bar | https://github.com/Alexays/Waybar/wiki | [waybar](https://github.com/ToaaMusic/dotfiles/tree/main/config/waybar) |
| **rofi** | App launcher | https://github.com/davatorium/rofi | [rofi](https://github.com/ToaaMusic/dotfiles/tree/main/config/rofi) |
| **kitty** | Terminal | https://sw.kovidgoyal.net/kitty/ | [kitty](https://github.com/ToaaMusic/dotfiles/tree/main/config/kitty) |
| **yazi** | Tui file manager | https://yazi-rs.github.io/ | [yazi](https://github.com/ToaaMusic/dotfiles/tree/main/config/yazi) |
| **mako** | Notification | https://github.com/emersion/mako | [mako](https://github.com/ToaaMusic/dotfiles/tree/main/config/mako) |
| **cava** | Tui audio visualizer | https://github.com/karlstav/cava | [cava](https://github.com/ToaaMusic/dotfiles/tree/main/config/cava) |



## 📦 Installation
To apply my configurations, clone the repository to a safe location you like, for example `~/repos`, and run `./link`. **Make sure to back up any existing configuration files before overwriting them.**

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
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

By the way, [.zshenv](https://github.com/ToaaMusic/dotfiles/tree/main/home/.zshenv) and [hypr/hyprland/env.lua](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr/hyprland/env.lua) will set $HOME/repos/dotfiles/ as TOAAM_DOTFILES. **And don't forget to rerun the `./link` after moving this repo**

## Dependencies
- `hyprpaper`: Wallpaper.
- `mpvpaper`: Dynamic wallpaper. (optional)
- `lua`: Tool language. (IMPORTANT)
- `grim`, `slurp`, `wl-copy`: Screenshot, Selection, and copy to clipboard
- `ffmpeg`: Img tool.

After installing the key components, if you want the full experience or just lazy to customize everything, you can simply install them all.

```bash
sudo pacman -S hyprland neovim fastfetch waybar rofi kitty yazi mako cava hyprpaper
```

```bash
sudo pacman -S musicfox grim slurp wl-copy mpvpaper lua ffmpeg
```

## Usage

### Shortcuts

See markdown in [config/hypr/](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr/) for more.

#### Default

| Shortcut           | Action                                   |
|--------------------|------------------------------------------|
| `ALT + Q`          | Open Terminal                            |
| `ALT + C`          | Close active window                      |
| `ALT + V`          | Toggle floating mode                     |
| `ALT + M`          | Exit Hyprland                            |
| `ALT + 1~0`        | Switch workspace 1~10                    |
| `ALT + SHIFT + 1~0`| Move window to workspace 1~10            |

#### Custom

| Shortcut           | Action                                   |
|--------------------|------------------------------------------|
| `ALT + F`          | Open File Manager (Yazi)                 |
| `ALT + Z`          | Open Music Player (Musicfox)             |
| `ALT + W`          | Set a random Wallpaper                   |
| `ALT + SHIFT + W`  | Set a random Dynamic Wallpaper           |
| `ALT + R`          | Refresh display / Waybar                 |
| `ALT + H`          | Toggle Waybar layout                     |
| `Print`            | Grab screen selection to clipboard       |

### Tools

See [tools/](https://github.com/ToaaMusic/dotfiles/tree/main/tools/) for more.

* **colorscheme/**

    Give `gen.lua` a **ppm** input and it will output `*.g.*` to `~/.config/*/`, then those components will apply the color scheme by themselves.

    ```bash
    grim -t ppm - | lua gen.lua
    ```  
    or
    ```bash
    ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua gen.lua
    ```

* **todo/**

    A lightweight Lua-based todo manager with interactive cross-day archive prompts and Markdown storage.

    ```bash
    lua todo.lua add "My new task"
    lua todo.lua ls
    lua todo.lua done 1
    lua todo.lua archive
    ```
