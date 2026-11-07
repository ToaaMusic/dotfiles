# My Arch Linux Configuration

[简体中文](./README.zh-CN.md) English version contains ai translations.

This repository stores my personal configuration for Archlinux(wayland) and some tools written in lua.

> [!WARNING]
> This repository is not yet ready to be used as a general-purpose configuration. Unless you have just installed the system and want to follow my configuration exactly, **it is not recommended** to use the installation method below, because this approach has (but is not limited to) the following problems:
>
> 1. Override support is poor. Most of these are my personal configs, so if you need to override anything, you'll have to fully understand the project and modify it yourself.
> 2. Version control is hard. If you customize anything locally, your copy will diverge from my repository.
> 3. Dependencies are not collected yet. Some scripts depend on certain packages; without installing them, you'll run into unknown behavior.
>
> Therefore I suggest you just look at my configuration files and copy what you need selectively — that also helps you learn. You can also fork this repository.

See [TODO.md](./TODO.md) for my plan.

![screenshot](https://enhiucyodopknrbdtswy.supabase.co/storage/v1/object/public/projects/screenshot.png)

## Components

| Component                                               | Description                   | Folder                          |
| ------------------------------------------------------- | ----------------------------- | ------------------------------- |
| [hyprland](https://wiki.hyprland.org/)                  | Wayland compositor (tiling)   | [hypr](./config/hypr)           |
| [labwc](https://labwc.github.io/)                       | Wayland compositor (stacking) | [labwc](./config/labwc)         |
| [nvim](https://neovim.io/)                              | Text editor                   | [nvim](./config/nvim)           |
| [opencode](https://opencode.ai/)                        | Ai coding agent               | [opencode](./config/opencode)   |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | System info fetcher           | [fastfetch](./config/fastfetch) |
| [waybar](https://github.com/Alexays/Waybar/wiki)        | Status bar                    | [waybar](./config/waybar)       |
| [rofi](https://github.com/davatorium/rofi)              | App launcher                  | [rofi](./config/rofi)           |
| [kitty](https://sw.kovidgoyal.net/kitty/)               | Terminal                      | [kitty](./config/kitty)         |
| [yazi](https://yazi-rs.github.io/)                      | Tui file manager              | [yazi](./config/yazi)           |
| [mako](https://github.com/emersion/mako)                | Notification                  | [mako](./config/mako)           |
| [cava](https://github.com/karlstav/cava)                | Tui audio visualizer          | [cava](./config/cava)           |

## Installation

> [!NOTE]
> It's self-contained so clone means install.

To apply my configurations, clone the repository to a safe location you like, for example `~/dotfiles`, and run `./link` ("-s" or "--select" option is recommended).

### About [link](./link)

**Before running `./link`, please check out the content of it or run `./link -h`.**

Simply, it is a script that creates symlinks from the subconfigs in my dotfiles repo to your appropriate configuration directories (`$HOME/*` and `$HOME/.config/*`).

Like this:

```bash
~/                            ~/dotfiles/
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

> [!IMPORTANT]
> Don't forget to rerun `./link` to make sure symlinks still work after moving this repo.
>
> And also, you may have to relogin your wm after that, because [.zshenv](./home/.zshenv) or [hypr/hyprland/env.lua](./config/hypr/hyprland/env.lua) will set the linked repo dir as $TOAAM_DOTFILES, which is the only env var required for locating and running my tool scripts.

> [!IMPORTANT]
> Make sure to back up any existing configuration files before overwriting them. ./link will also check and ask for overwriting or not.

```bash
cd ~
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
./link -s
```

## Uninstallation

Run `./link clean` to remove the linked configs or overwrite those linked configs with your own then just remove this repo you cloned.

## Structure & Dependencies

```bash
# path                          deps

config
├── cava
├── dunst
├── fastfetch
├── fontconfig                  ttf-maplemono-nf-cn-unhinted, ttf-lxgw-zhenkai, ttf-chillroundm(aur)
├── git                         git-delta
├── gtk-3.0
├── gtk-4.0
├── hypr
│   ├── hyprland
│   │   ├── autostart.lua       tools/start-hyprpaper.sh
│   │   ├── binds.lua           rofi, waybar, tools/
│   │   ├── colors.lua
│   │   ├── devices.lua
│   │   ├── env.lua
│   │   ├── monitors.lua
│   │   ├── rules.lua
│   │   └── vars.lua
│   ├── shaders
│   ├── default.conf
│   ├── hyprland.lua
│   ├── hyprlock.conf           hyprlock
│   ├── hyprpaper.conf          hyprpaper
│   └── README.md
├── kitty
├── mako
├── nvim
├── opencode
├── quickshell
├── rofi
├── waybar
│   ├── bars
│   ├── menus
│   ├── modules
│   ├── scripts
│   │   ├── get-weather.sh
│   │   ├── im-stat.sh
│   │   ├── notify-stat.sh
│   │   └── notify-toggle.sh
│   ├── styles
│   ├── config.jsonc
│   └── style.css
└── yazi
    ├── plugins
    ├── init.lua
    ├── keymap.toml
    ├── package.toml
    └── yazi.toml
home
tools
├── colorscheme                 lua
├── shared
│   ├── Config.lua
│   ├── file_helper.lua
│   ├── getopt.lua
│   ├── logger.lua
│   └── plugin.lua              lua-language-server
├── todo                        lua
├── bar.sh                      waybar
├── gen-color-part.sh           grim, tolls/colorscheme
├── gen-color.sh                grim, slurp, tools/colorscheme
├── kv.sh
├── refresh.sh                  waybar
├── start-hyprpaper.sh          hyprpaper
└── wall.sh                     hyprland, hyprpaper, rofi, ffmpeg, tools/colorscheme, tools/kv.sh
LICENSE
link
README.md
README.zh-CN.md
TODO.md
```
