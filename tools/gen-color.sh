#!/usr/bin/env bash

grim -t ppm - | lua ~/repos/linux/dotfiles/tools/chromia/gen.lua

# chmod +x tools/shell/gen-color.sh