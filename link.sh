#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

for dir in "$DOTFILES_DIR"/*/; do
  name="$(basename "$dir")"
  target="$CONFIG_DIR/$name"

  if [[ -L "$target" ]]; then
    # Existing symlink
    read -rp "$name already exists as a symlink. Override? [y/N] " answer
    case "$answer" in
      [Yy]*)
        rm -f "$target"
        ;;
      *)
        echo "Skipping $name"
        continue
        ;;
    esac
  elif [[ -d "$target" ]]; then
    # Existing directory
    if [[ "$(ls -A "$target")" ]]; then
      read -rp "$name already exists and is a non-empty directory. Override? [y/N] " answer
      case "$answer" in
        [Yy]*)
          rm -rf "$target"
          ;;
        *)
          echo "Skipping $name"
          continue
          ;;
      esac
    else
      # Empty directory
      rm -rf "$target"
    fi
  elif [[ -e "$target" ]]; then
    # Existing file
    read -rp "$name already exists as a file. Override? [y/N] " answer
    case "$answer" in
      [Yy]*)
        rm -f "$target"
        ;;
      *)
        echo "Skipping $name"
        continue
        ;;
    esac
  fi

  ln -s "$dir" "$target"
  echo "Linked $name"
done
