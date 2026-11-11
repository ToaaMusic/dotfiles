# My Arch Linux Configuration

这个仓库包含了我的Arch系统配置和一些我用lua写的小工具。

> [!WARNING]
> 这个仓库目前还没准备好作为通用配置使用，除非你是刚装的系统，想完全跟着我的配置来，否则**不建议**使用下面的安装方式，因为这种方式存在且不限于以下问题：
>
> 1. 覆盖配置功能欠佳。我的个人配置居多，如果你需要写覆盖配置，那么需要完全理解项目自己去修改。
> 2. 版本控制难。如果你本地做了个性化修改，那么将和我的仓库分叉。
> 3. 依赖还未汇总。有些脚本会依赖一些包，如果你不安装它们，运行后会有未知行为。
>
> 因此建议你直接查看我的配置文件并去有取舍地 copy，这样也有助于你学习。你也可以 fork 这个仓库。

查看 [TODO.md](./TODO.md) 获取我的改动计划

![screenshot](https://enhiucyodopknrbdtswy.supabase.co/storage/v1/object/public/projects/screenshot.png)

## 成分

| 成分                                                    | 解释                  | 位置                            |
| ------------------------------------------------------- | --------------------- | ------------------------------- |
| [hyprland](https://wiki.hyprland.org/)                  | Wayland 合成器 (平铺) | [hypr](./config/hypr)           |
| [labwc](https://labwc.github.io/)                       | Wayland 合成器 (堆叠) | [labwc](./config/labwc)         |
| [nvim](https://neovim.io/)                              | 文本编辑器            | [nvim](./config/nvim)           |
| [opencode](https://opencode.ai/)                        | Ai 编程助手           | [opencode](./config/opencode)   |
| [fastfetch](https://github.com/fastfetch-cli/fastfetch) | 系统信息              | [fastfetch](./config/fastfetch) |
| [waybar](https://github.com/Alexays/Waybar/wiki)        | Bar                   | [waybar](./config/waybar)       |
| [rofi](https://github.com/davatorium/rofi)              | App 启动器            | [rofi](./config/rofi)           |
| [kitty](https://sw.kovidgoyal.net/kitty/)               | 终端模拟器            | [kitty](./config/kitty)         |
| [yazi](https://yazi-rs.github.io/)                      | Tui 文件管理器        | [yazi](./config/yazi)           |
| [mako](https://github.com/emersion/mako)                | 通知                  | [mako](./config/mako)           |
| [cava](https://github.com/karlstav/cava)                | Tui 可视化音频        | [cava](./config/cava)           |

## 安装

> [!NOTE]
> 项目被设计为自包含的，因此 clone 即安装。

克隆本仓库到你喜欢的任何位置（例如 `~/dotfiles`），然后执行 `./link`（建议带 `-s` 参数选择性安装）。

### 关于 [link](./link)

**运行 `./link` 之前，请先查看其内容，也可运行 `./link -h` 查看帮助。**

简单来说，该脚本会从本仓库的 `config/` 和 `home/` 子目录创建符号链接到对应的配置目录（`$HOME/*` 和 `$HOME/.config/*`）。

如图:

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

> [!IMPORTANT]
> 移动本仓库后，别忘了重新运行 `./link` 确保链接有效。
>
> 你可能还需要重新登录你的窗口管理器，因为 [.zshenv](./home/.zshenv) 和 [hypr/hyprland/env.lua](./config/hypr/hyprland/env.lua) 会将仓库目录设为 `$TOAAM_DOTFILES` 环境变量来定位和运行我的脚本。

> [!IMPORTANT]
> 请务必备份已有的配置文件，以防被覆盖。同时 ./link 也会检查并询问是否覆盖。

```bash
cd ~
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
./link -s
```

## 卸载

运行 `./link clean` 来清理链接过的配置项或者用你自己的配置覆盖那些符号链接，然后直接删掉你克隆的仓库即可。

## 项目结构 & 依赖

```bash
# path                          deps(include tools)

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
├── labwc
│   ├── autostart               kanshi, fcitx5, swaybg, tools/kv.sh
│   ├── environment
│   ├── menu.xml                kitty, rofi, tools/wall.sh
│   ├── rc.xml                  rofi, kitty, musicfox, tools/
│   └── themerc-override
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
