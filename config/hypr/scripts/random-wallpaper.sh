#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/wallpapers"

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

