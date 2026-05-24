#!/usr/bin/env bash

LOCKDIR="/tmp/random-wallpaper.lock"
if ! mkdir "$LOCKDIR" 2>/dev/null; then
	# stale lock from kill -9? check if any wallpaper script is actually running
	if ! pgrep -f "random-wallpaper\.sh" | grep -qv "$$"; then
		rm -rf "$LOCKDIR"
		mkdir "$LOCKDIR" || { notify-send "Wallpaper" "Failed to acquire lock" -t 2000; exit 0; }
	else
		notify-send "Wallpaper" "Already changing, please wait" -t 2000
		exit 0
	fi
fi
trap 'rm -rf "$LOCKDIR"' EXIT

# $1 or random wallpaper
WALLDIR="$HOME/Pictures/wallpapers/current"

if [ -n "$1" ]; then
  WALL=$1
else
  WALL=$(find "$WALLDIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)
fi

# set
hyprctl hyprpaper wallpaper ",$WALL"

# gen color
GEN_LUA="$TOAAM_DOTFILES/tools/colorscheme/gen.lua"
ffmpeg -v error -i "$WALL" -f image2pipe -vcodec ppm - | lua "$GEN_LUA"

# cache
KV_FILE="$TOAAM_DOTFILES/.cache"
kv="$TOAAM_DOTFILES/scripts/kv.sh"
$kv $KV_FILE wallpaper $WALL

# notify
notify-send "Wallpaper Changed" "$(basename "$WALL")" -i "$WALL"
