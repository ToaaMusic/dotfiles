#!/bin/bash
# Launch hyprpaper and set wallpaper from cache, retrying until hyprpaper is ready
# Falls back to /usr/share/hypr/wall{0,1,2}.png if cached wallpaper is missing

hyprpaper &

WALL=$("$TOAAM_DOTFILES/scripts/kv.sh" "$TOAAM_DOTFILES/.cache" wallpaper 2>/dev/null)
if [ -z "$WALL" ] || [ ! -f "$WALL" ]; then
	WALL=""
	for i in 0 1 2; do
		if [ -f "/usr/share/hypr/wall$i.png" ]; then
			WALL="/usr/share/hypr/wall$i.png"
			break
		fi
	done
fi

if [ -z "$WALL" ]; then
	echo "No wallpaper found (cache missing/invalid and no default wallpapers)" >&2
	exit 1
fi

for i in $(seq 1 50); do
	if hyprctl hyprpaper wallpaper ",$WALL" 2>/dev/null; then
		exit 0
	fi
	sleep 0.1
done

echo "hyprpaper wallpaper failed after 5s" >&2
exit 1
