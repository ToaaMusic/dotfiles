#!/usr/bin/env bash

rofi -show filebrowser \
     -theme filebrowser \
     -filebrowser-directory $HOME/Pictures/wallpapers/ \
     -filebrowser-command $TOAAM_DOTFILES/config/hypr/cmds/wall.sh
