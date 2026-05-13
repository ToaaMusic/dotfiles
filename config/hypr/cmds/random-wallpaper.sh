#!/usr/bin/env bash

WALLDIR="$HOME/Pictures/wallpapers/current"
WALL=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)

hyprctl hyprpaper wallpaper ",$WALL"

notify-send "Wallpaper Changed" "$(basename "$WALL")" -i "$WALL"

# gen color
GEN_LUA="$TOAAM_DOTFILES/tools/colorscheme/gen.lua"
ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua "$GEN_LUA"

# cache
KV_FILE="$TOAAM_DOTFILES/.cache"
kv="$TOAAM_DOTFILES/scripts/kv.sh"

$kv $KV_FILE wallpaper $WALL
