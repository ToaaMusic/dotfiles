# My Arch Linux Configuration

[简体中文](./README.zh-CN.md)

This repository contains my personal configuration for Arch Linux and some tools written by lua script.

## Components

| Component     | Description          | Official Doc                               | Repository Folder               |
| ------------- | -------------------- | ------------------------------------------ | ------------------------------- |
| **hyprland**  | Wayland compositor   | https://wiki.hyprland.org/                 | [hypr](./config/hypr)           |
| **nvim**      | Text editor          | https://neovim.io/                         | [nvim](./config/nvim)           |
| **fastfetch** | System info fetcher  | https://github.com/fastfetch-cli/fastfetch | [fastfetch](./config/fastfetch) |
| **waybar**    | Status bar           | https://github.com/Alexays/Waybar/wiki     | [waybar](./config/waybar)       |
| **rofi**      | App launcher         | https://github.com/davatorium/rofi         | [rofi](./config/rofi)           |
| **kitty**     | Terminal             | https://sw.kovidgoyal.net/kitty/           | [kitty](./config/kitty)         |
| **yazi**      | Tui file manager     | https://yazi-rs.github.io/                 | [yazi](./config/yazi)           |
| **mako**      | Notification         | https://github.com/emersion/mako           | [mako](./config/mako)           |
| **cava**      | Tui audio visualizer | https://github.com/karlstav/cava           | [cava](./config/cava)           |

## Installation

To apply my configurations, clone the repository to a safe location you like, for example `~/repos`, and run `./link` ("select" param is recommended).

> [!IMPORTANT]
> Make sure to back up any existing configuration files before overwriting them. ./link will also check and ask for overwriting or not.

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
./link select
```

### About [link](./link)

**Before running `./link`, please check out the content of it and run `./link -h` for help.**

Simply, it is a script that creates symlinks from the subconfigs in my dotfiles repo to your appropriate configuration directories (`$HOME/*` and `$HOME/.config/*`).

Like this:

```bash
~/                            ~/repos/dotfiles/
├── .config/                  ├── config/
│   ├── hypr    --------->    │   ├── hypr
│   ├── waybar  --------->    │   ├── waybar
│   ├── rofi    --------->    │   ├── rofi
│   ├── kitty   --------->    │   ├── kitty
│   └── ...     --------->    │   └── ...
│                             │
│                             ├── home/
├── .zshrc      --------->    │   ├── .zshrc
├── .zshenv     --------->    │   ├── .zshenv
└── ...                       └── ...
```

> [!NOTE]
> Don't forget to rerun the `./link` after moving this repo. So that [.zshenv](./home/.zshenv) and [hypr/hyprland/env.lua](./config/hypr/hyprland/env.lua) will auto set the linked repo dir as $TOAAM_DOTFILES, which is the only env var required for running my tool scripts and locating some resources.

## Uninstallation

Just remove this repo you cloned and overwrite those linked configs with your own.

## Dependencies

It's up to you.

After installing the key components to apply, if you want the full experience or just lazy to customize everything, you can simply install the deps all.

```bash
sudo pacman -S hyprland neovim fastfetch waybar rofi kitty yazi mako cava hyprpaper
```

```bash
sudo pacman -S lua grim slurp wl-copy ffmpeg
```

- `lua`: for running my tools. (IMPORTANT)
- `hyprpaper`: for showing wallpaper.
- `grim`, `slurp`, `wl-copy`, `ffmpeg`: Screenshot, Selection, and copy to clipboard. for using color generation tool.

## Usage

### Shortcuts

See markdown in [config/hypr/](./config/hypr/) for more.

#### Default

| Shortcut            | Action                        |
| ------------------- | ----------------------------- |
| `ALT + Q`           | Open Terminal                 |
| `ALT + C`           | Close active window           |
| `ALT + V`           | Toggle floating mode          |
| `ALT + M`           | Exit Hyprland                 |
| `ALT + 1~0`         | Switch workspace 1~10         |
| `ALT + SHIFT + 1~0` | Move window to workspace 1~10 |

#### Custom

| Shortcut          | Action                             |
| ----------------- | ---------------------------------- |
| `ALT + F`         | Open File Manager (Yazi)           |
| `ALT + Z`         | Open Music Player (Musicfox)       |
| `ALT + W`         | Set a random Wallpaper             |
| `ALT + SHIFT + W` | Open wallpaper gui selection       |
| `ALT + R`         | Refresh display / Waybar           |
| `ALT + H`         | Toggle Waybar layout               |
| `Print`           | Grab screen selection to clipboard |

### Tools

[tools/](./tools/)

- **colorscheme/**

  Give `gen.lua` a **ppm** input and it will output `*.g.*` to `~/.config/*/`, then those components will apply the color scheme by themselves.

  ```bash
  grim -t ppm - | lua gen.lua
  ```

  or

  ```bash
  ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua gen.lua
  ```

- **todo/**

  A lightweight Lua-based todo manager with interactive cross-day archive prompts and Markdown storage.

  ```bash
  lua todo.lua add "My new task"
  lua todo.lua ls
  lua todo.lua done 1
  lua todo.lua arch
  ```
