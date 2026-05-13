#!/usr/bin/env bash

CSS="$HOME/.config/waybar/style.css"
CFG="$HOME/.config/waybar/config.jsonc"

if grep -q 'styles/horizontal\.css' "$CSS"; then
  # vertical
  sed -i 's@styles/horizontal\.css@styles/vertical.css@g' "$CSS"
  sed -i 's@bars/horizontal\.jsonc@bars/vertical.jsonc@g' "$CFG"
  echo "Waybar → vertical"
else
  # horizontal
  sed -i 's@styles/vertical\.css@styles/horizontal.css@g' "$CSS"
  sed -i 's@bars/vertical\.jsonc@bars/horizontal.jsonc@g' "$CFG"
  echo "Waybar → horizontal"
fi

pkill waybar
waybar &
