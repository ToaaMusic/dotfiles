#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/wallpapers/current"

WALL=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)

# hyprctl hyprpaper wallpaper '[mon], [path], [fit_mode]'

echo "$WALL"

#hyprctl hyprpaper reload "eDP-1,$WALL"

# or

# hyprctl hyprpaper preload "$WALL"
# hyprctl hyprpaper wallpaper "eDP-1,$WALL"
# hyprctl hyprpaper unload unused

# newest

hyprctl hyprpaper wallpaper ",$WALL"

# send notification 只显示图片名字
notify-send "Wallpaper Changed" "$(basename "$WALL")" -i "$WALL"

# 得到gen.lua路径
HYPR_PATH="$HOME/.config/hypr"
if [ ! -L "$HYPR_PATH" ]; then
    exit 0
fi
TARGET_DIR="$(readlink -f "$HYPR_PATH")"
if [ ! -d "$TARGET_DIR" ]; then
    exit 0
fi
PARENT_DIR="$(dirname "$(dirname "$TARGET_DIR")")"
GEN_LUA="$PARENT_DIR/tools/colorscheme/gen.lua"

# 生成配色
ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua "$GEN_LUA"

