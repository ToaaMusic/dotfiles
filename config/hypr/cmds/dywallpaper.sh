#!/usr/bin/env bash

WALL_VIDEO="$HOME/Downloads/补帧+拼接/gachapopup_miyabi_loop.mp4"

pkill hyprpaper
pkill mpvpaper

mpvpaper -o "--loop=inf --no-audio --panscan=1" eDP-1 "$WALL_VIDEO"

notify-send "Wallpaper Changed" "New wallpaper set." -i "$WALL_VIDEO"
