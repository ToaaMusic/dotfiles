#!/usr/bin/env bash

include_scripts_dir="$TOAAM_DOTFILES/tools"
cache_dir="$TOAAM_DOTFILES/.cache"
bar_name=$($include_scripts_dir/kv.sh $cache_dir/state "bar")

$include_scripts_dir/bar.sh $bar_name
