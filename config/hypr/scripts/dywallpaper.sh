#!/usr/bin/env bash

# Set video wallpaper using mpvpaper
pkill hyprpaper
pkill mpvpaper

mpvpaper -o "--loop=inf --no-audio --panscan=1" eDP-1 /home/ToaaM/Downloads/补帧+拼接/gachapopup_miyabi_loop.mp4

# send notification
notify-send "Wallpaper Changed" "New wallpaper set." -i /home/ToaaM/Downloads/补帧+拼接/gachapopup_miyabi_loop.mp4
