#!/usr/bin/env bash

pkill waybar

waybar & 

pkill hyprpaper
pkill mpvpaper

hyprpaper &


# hyprctl dispatch reload