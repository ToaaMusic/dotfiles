#!/usr/bin/env bash

HYPR_PATH="$HOME/.config/hypr"

if [ ! -L "$HYPR_PATH" ]; then
    exit 0
fi

# 获取 symlink 指向的真实路径
TARGET_DIR="$(readlink -f "$HYPR_PATH")"

# 如果目标不存在，退出
if [ ! -d "$TARGET_DIR" ]; then
    exit 0
fi

# 获取dotfiles目录
PARENT_DIR="$(dirname "$(dirname "$TARGET_DIR")")"

# tools/colorscheme/gen.lua 路径
GEN_LUA="$PARENT_DIR/tools/colorscheme/gen.lua"

# 如果 gen.lua 存在则执行
if [ -f "$GEN_LUA" ]; then
  GEOM="$(slurp)" || exit 0
  [ -n "$GEOM" ] || exit 0
  grim -g "$GEOM" -t ppm - | lua "$GEN_LUA"
fi
