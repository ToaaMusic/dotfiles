# My Arch Linux Configuration

这个仓库包含了我的Arch系统配置和一些我用lua写的小工具。

## 成分

| 成分 | 描述 | 官方Docs/Wiki | 仓库位置 |
|---|---|---|---|
| **hyprland** | Wayland 窗口合成器 | https://wiki.hyprland.org/ | [hypr](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr) |
| **fastfetch** | 系统信息获取器 | https://github.com/fastfetch-cli/fastfetch | [fastfetch](https://github.com/ToaaMusic/dotfiles/tree/main/config/fastfetch) |
| **waybar** | 状态栏 | https://github.com/Alexays/Waybar/wiki | [waybar](https://github.com/ToaaMusic/dotfiles/tree/main/config/waybar) |
| **rofi** | App 启动器 | https://github.com/davatorium/rofi | [rofi](https://github.com/ToaaMusic/dotfiles/tree/main/config/rofi) |
| **kitty** | 终端模拟器 | https://sw.kovidgoyal.net/kitty/ | [kitty](https://github.com/ToaaMusic/dotfiles/tree/main/config/kitty) |
| **yazi** | Tui 文件管理器 | https://yazi-rs.github.io/ | [yazi](https://github.com/ToaaMusic/dotfiles/tree/main/config/yazi) |
| **dunst** | 通知 | https://dunst-project.org/ | [dunst](https://github.com/ToaaMusic/dotfiles/tree/main/config/dunst) |
| **cava** | 音频可视化 | https://github.com/karlstav/cava | [cava](https://github.com/ToaaMusic/dotfiles/tree/main/config/cava) |

## 安装
克隆本仓库到你喜欢的任何位置，然后执行 `link`。

```bash
git clone https://github.com/ToaaMusic/dotfiles.git
cd dotfiles
./link
```

`link` 脚本会将各配置文件链接到对应位置。

如图:

```bash
~/.config  symlink to  ~/repos/dotfiles/config
├── hypr   --------->  ├── hypr
├── waybar --------->  ├── waybar
├── rofi   --------->  ├── rofi
├── kitty  --------->  ├── kitty
└── ...                      └── ...
```

## 依赖
- `hyprpaper` <- 壁纸.
- `mpvpaper` <- 动态壁纸. (可选)
- `lua` ~ 脚本语言. (重要)
- `grim`, `slurp`, `wl-copy` <- 截屏，选区，与粘贴板
- `ffmpeg` ~ 媒体工具.

```bash
sudo pacman -S kitty hyprland hyprpaper waybar fastfetch rofi dunst cava yazi
```

```bash
sudo pacman -S musicfox grim slurp wl-copy mpvpaper lua ffmpeg
```

## 使用

### 快捷键

更多细节见 [config/hypr/](https://github.com/ToaaMusic/dotfiles/tree/main/config/hypr/)

#### 默认

| 快捷键              | 作用                                     |
|--------------------|------------------------------------------|
| `ALT + C`          | Close active window                      |
| `ALT + M`          | Exit hyprland                            |
| `ALT + V`          | Toggle floating mode for                 |
| `ALT + Q`          | Open Terminal                            |
| `ALT + 1~9`        | Switch workspace                         |
| `ALT + SHIFT + 1~9`| Move window to target workspace          |
| `F11`              | Toggle fullsceen                         |
|``||

#### 自定义

| 快捷键              | 作用                                     |
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

### 工具

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
