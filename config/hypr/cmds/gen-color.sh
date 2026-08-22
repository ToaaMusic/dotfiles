#!/usr/bin/env bash

GEN_LUA="$TOAAM_DOTFILES/tools/colorscheme/gen.lua"

if [ -f "$GEN_LUA" ]; then
  grim -t ppm - | lua "$GEN_LUA"
fi
