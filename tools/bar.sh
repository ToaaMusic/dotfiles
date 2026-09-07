#!/bin/bash
# change-bar.sh

include_scripts_dir="$TOAAM_DOTFILES/tools"
cache_dir="$TOAAM_DOTFILES/.cache"
bar_name="$1"

# check null
if [[ -z "$bar_name" ]]; then
	echo "Usage: $0 <bar_name>"
	exit 1
fi

bar_config="$HOME/.config/waybar/bars/$bar_name.jsonc"
bar_style="$HOME/.config/waybar/styles/$bar_name.css"

pkill waybar

if [[ ! -f "$bar_config" ]]; then
	echo "Config file not found: $bar_config"
	exit 1
fi

if [[ -f "$bar_style" ]]; then
	waybar -c "$bar_config" -s "$bar_style" &
else
	waybar -c "$bar_config" &
fi

$include_scripts_dir/kv.sh $cache_dir/state "bar" $bar_name
