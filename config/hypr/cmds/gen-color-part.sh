#!/usr/bin/env bash

GEN_LUA="$TOAAM_DOTFILES/tools/colorscheme/gen.lua"

if [ -f "$GEN_LUA" ]; then
  GEOM="$(slurp)" || exit 0
  [ -n "$GEOM" ] || exit 0
  grim -g "$GEOM" -t ppm - | lua "$GEN_LUA"
fi
