#!/usr/bin/env bash

CSS="$HOME/.config/waybar/style.css"
CFG="$HOME/.config/waybar/config.jsonc"

# --- 判断当前布局 ---
if grep -q 'styles/horizontal\.css' "$CSS"; then
  # 切到 vertical
  sed -i 's@styles/horizontal\.css@styles/vertical.css@g' "$CSS"
  sed -i 's@bars/horizontal\.jsonc@bars/vertical.jsonc@g' "$CFG"
  echo "Waybar → vertical"
else
  # 切到 horizontal
  sed -i 's@styles/vertical\.css@styles/horizontal.css@g' "$CSS"
  sed -i 's@bars/vertical\.jsonc@bars/horizontal.jsonc@g' "$CFG"
  echo "Waybar → horizontal"
fi

# 重启 waybar
pkill waybar && waybar &
