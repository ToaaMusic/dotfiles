# My Arch Linux Configuration

这个仓库包含了我的Arch系统配置和一些我用lua写的小工具。

你可以查看 [TODO.md](./TODO.md) 获取改动计划

![screenshot](https://enhiucyodopknrbdtswy.supabase.co/storage/v1/object/public/projects/screenshot.png)

## 成分

| 成分          | 描述               | 官方Docs/Wiki                              | 仓库位置                        |
| ------------- | ------------------ | ------------------------------------------ | ------------------------------- |
| **hyprland**  | Wayland 窗口合成器 | https://wiki.hyprland.org/                 | [hypr](./config/hypr)           |
| **nvim**      | 文本编辑器         | https://neovim.io/                         | [nvim](./config/nvim)           |
| **fastfetch** | 系统信息获取器     | https://github.com/fastfetch-cli/fastfetch | [fastfetch](./config/fastfetch) |
| **waybar**    | 状态栏             | https://github.com/Alexays/Waybar/wiki     | [waybar](./config/waybar)       |
| **rofi**      | App 启动器         | https://github.com/davatorium/rofi         | [rofi](./config/rofi)           |
| **kitty**     | 终端模拟器         | https://sw.kovidgoyal.net/kitty/           | [kitty](./config/kitty)         |
| **yazi**      | Tui 文件管理器     | https://yazi-rs.github.io/                 | [yazi](./config/yazi)           |
| **mako**      | 通知               | https://github.com/emersion/mako           | [mako](./config/mako)           |
| **cava**      | 音频可视化         | https://github.com/karlstav/cava           | [cava](./config/cava)           |

## 安装

克隆本仓库到你喜欢的任何位置（例如 `~/repos`），然后执行 `./link`（建议带 `-s` 参数选择性安装）。

> [!IMPORTANT]
> 请务必备份已有的配置文件，以防被覆盖。同时 ./link 也会检查并询问是否覆盖。

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
./link -s
```

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

> [!NOTE]
> 移动本仓库后，别忘了重新运行 `./link`。这样 [.zshenv](./home/.zshenv) 和 [hypr/hyprland/env.lua](./config/hypr/hyprland/env.lua) 会自动将仓库目录设为 `$TOAAM_DOTFILES` 环境变量，这是运行我的工具脚本和定位资源所必需的。

## 卸载

运行 `./link clean` 来清理链接过的配置项或者用你自己的配置覆盖那些符号链接，然后直接删掉你克隆的仓库即可。

## 依赖

随你喜好。

装好关键组件后，如果想获得完整体验或懒得逐一配置，可以直接全部安装。

```bash
sudo pacman -S hyprland neovim fastfetch waybar rofi kitty yazi mako cava hyprpaper
```

```bash
sudo pacman -S lua grim slurp wl-copy ffmpeg
```

- `lua`：运行我的工具脚本。（重要）
- `hyprpaper`：显示壁纸。
- `grim`、`slurp`、`wl-copy`、`ffmpeg`：截图、选区与剪贴板，供颜色生成工具使用。

## 使用

### 快捷键

更多细节见 [config/hypr/](./config/hypr/)

#### 默认

| 快捷键              | 作用                        |
| ------------------- | --------------------------- |
| `ALT + Q`           | 打开一个终端模拟器（Kitty） |
| `ALT + C`           | 关闭窗口                    |
| `ALT + V`           | 切换窗口浮动                |
| `ALT + M`           | 退出Hyprland                |
| `ALT + 1~0`         | 切换工作区 1~10             |
| `ALT + SHIFT + 1~0` | 把窗口移到工作区 1~10       |

#### 自定义

| 快捷键            | 作用                          |
| ----------------- | ----------------------------- |
| `ALT + F`         | 打开一个文件管理器 (Yazi)     |
| `ALT + Z`         | 打开一个音乐播放器 (Musicfox) |
| `ALT + W`         | 随机设置一个壁纸              |
| `ALT + SHIFT + W` | 打开壁纸设置面板              |
| `ALT + R`         | 刷新                          |
| `ALT + H`         | 切换状态栏横竖布局            |
| `Print`           | 截取选中区域到剪贴板          |

### 工具

[tools/](./tools/)

- **colorscheme/**

  向 `gen.lua` 传入 **ppm** 格式的输入，它会将 `*.g.*` 输出到 `~/.config/*/`，随后各组件会自动应用配色方案。

  ```bash
  grim -t ppm - | lua gen.lua
  ```

  或

  ```bash
  ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua gen.lua
  ```

- **todo/**

  一个轻量级的 Lua 待办事项管理器，支持交互式跨日归档提醒和 Markdown 存储。

  ```bash
  lua todo.lua add "My new task"
  lua todo.lua ls
  lua todo.lua done 1
  lua todo.lua arch
  ```
