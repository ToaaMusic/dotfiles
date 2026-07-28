#!/bin/bash
# change-bar.sh

bar_name="${1:-horizontal}"

bar_config="$HOME/.config/waybar/bars/$bar_name.jsonc"
bar_style="$HOME/.config/waybar/styles/$bar_name.css"

pkill waybar

if [[ -f "$bar_style" ]]; then
	waybar -c "$bar_config" -s "$bar_style" &
else
	waybar -c "$bar_config" &
fi

$TOAAM_DOTFILES/scripts/kv.sh $TOAAM_DOTFILES/.cache "bar" $bar_name
