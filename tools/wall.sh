#!/usr/bin/env bash
# vim:foldmethod=marker
# vim:foldmarker={{{,}}}

# lock {{{

LOCKDIR="/tmp/wall.lock"
if ! mkdir "$LOCKDIR" 2>/dev/null; then
	# stale lock from kill -9? check if any wallpaper script is actually running
	if ! pgrep -f "wall\.sh" | grep -qv "$$"; then
		rm -rf "$LOCKDIR"
		mkdir "$LOCKDIR" || {
			notify-send "Wallpaper" "Failed to acquire lock" -t 2000
			exit 0
		}
	else
		notify-send "Wallpaper" "Already changing, please wait" -t 2000
		exit 0
	fi
fi
trap 'rm -rf "$LOCKDIR"' EXIT

# }}}

walls_dir="$HOME/Pictures/wallpapers/current"
include_scripts_dir="$TOAAM_DOTFILES/tools"
cache_dir="$TOAAM_DOTFILES/.cache"

# help {{{

show_usage() {
	cat <<'EOF'
usage: wall.sh [-h] [-w] [-f FILE] [-g] [-d DIR]

optional arguments:
  -h, --help            show this help message
  -w, --web             download wallpaper from web and apply it
  -f, --file FILE       set a specific wallpaper file
  -g, --gui             open filebrowser GUI, -d is optional
  -d, --dir DIR         specify directory to pick from
EOF
}

# }}}

set_wall() {
	hyprctl hyprpaper wallpaper ",$1"

	# cache
	KV_FILE="$cache_dir/state"
	kv="$include_scripts_dir/kv.sh"
	$kv $KV_FILE wallpaper $1

	if [ ! -f "$HOME/.config/hypr/cache.conf" ]; then
		touch "$HOME/.config/hypr/cache.conf"
	fi
	echo "\$wall=$1" >"$HOME/.config/hypr/cache.conf"

	# gen color
	GEN_LUA="$include_scripts_dir/colorscheme/gen.lua"
	ffmpeg -v error -i "$1" -f image2pipe -vcodec ppm - | lua "$GEN_LUA"
}

main() {
	temp=$(getopt -o hwf:gd: --long help,web,file,gui,dir -n "$0" -- "$@") || {
		show_usage
		exit 1
	}
	eval set -- "$temp"

	local has_mode_opt=false
	local opt_help=false
	local opt_web=false
	local opt_gui=false
	local opt_file

	check_conflict() {
		if [[ $has_mode_opt == "true" ]]; then
			echo "Error: -wfd are mutually exclusive"
			exit 1
		else
			has_mode_opt=true
		fi
	}

	while true; do
		case "$1" in
		-h | --help) opt_help=true && shift ;;
		-w | --web) check_conflict && opt_web=true && shift ;;
		-f | --file) check_conflict && opt_file=$2 && shift 2 ;;
		-g | --gui) opt_gui=true && shift ;;
		-d | --dir) check_conflict && walls_dir=$2 && shift 2 ;;
		--) shift && break ;;
		*) break ;;
		esac
	done

	if [[ $opt_help == "true" ]]; then
		show_usage
		exit 0
	fi

	if [[ $opt_gui == "true" ]]; then
		rm -rf "$LOCKDIR"
		rofi -show filebrowser \
			-theme filebrowser \
			-filebrowser-directory "$walls_dir" \
			-filebrowser-command "$include_scripts_dir/wall.sh -f"
		exit 0
	fi

	if [[ $opt_web == "true" ]]; then
		WALL_CACHE="$cache_dir/wall_cache.png"

		curl -sfL --max-time 10 "https://api.yppp.net/pc.php" -o $WALL_CACHE

		if [ -f "$WALL_CACHE" ]; then
			set_wall $WALL_CACHE
			exit 0
		fi
		exit 0
	fi

	if [[ $opt_file != "" ]]; then
		WALL=$opt_file
	else
		WALL=$(find "$walls_dir" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.jpeg' \) | shuf -n 1)
	fi

	set_wall $WALL
}

main "$@"
