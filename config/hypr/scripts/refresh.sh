#!/usr/bin/env bash

pkill waybar

waybar --config ~/.config/waybar/bars/horizontal.jsonc --style ~/.config/waybar/style.css & 

pkill hyprpaper
pkill mpvpaper

hyprpaper &


# hyprctl dispatch reload