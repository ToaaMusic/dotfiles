#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_TARGET_DIR="$DOTFILES_DIR/config"
HOME_TARGET_DIR="$DOTFILES_DIR/home"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

declare -A selections
declare -a all_items

for dir in "$CONFIG_TARGET_DIR"/*/; do
  name="$(basename "$dir")"
  all_items+=("config:$name:$dir")
done

for file in "$HOME_TARGET_DIR"/.*; do
  name="$(basename "$file")"
  [[ "$name" == "." || "$name" == ".." ]] && continue
  all_items+=("home:$name:$file")
done

if command -v fzf &>/dev/null; then
  selected=$(
    for item in "${all_items[@]}"; do
      type="${item%%:*}"
      rest="${item#*:}"
      name="${rest%%:*}"
      echo "$type:$name"
    done | fzf --multi --height=50% --reverse --prompt "Select configs to link: " --header "Space to select, Enter to confirm"
  )
  
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    type="${line%%:*}"
    name="${line#*:}"
    selections["$type:$name"]=1
  done <<< "$selected"
else
  echo "=== Select configs to link ==="
  echo "Use space to toggle, Enter to confirm"
  echo ""
  
  for i in "${!all_items[@]}"; do
    item="${all_items[$i]}"
    type="${item%%:*}"
    rest="${item#*:}"
    name="${rest%%:*}"
    printf "%3d) [ ] %s/%s\n" "$i" "$type" "$name"
  done
  
  echo ""
  echo "Enter numbers separated by comma (e.g., 1,3,5) or 'a' for all: "
  read -r input
  
  if [[ "$input" =~ ^[Aa]$ ]]; then
    for item in "${all_items[@]}"; do
      selections["$item"]=1
    done
  else
    IFS=',' read -ra nums <<< "$input"
    for num in "${nums[@]}"; do
      num=$((num))
      if [[ $num -ge 0 && $num -lt ${#all_items[@]} ]]; then
        selections["${all_items[$num]}"]=1
      fi
    done
  fi
fi

if [[ ${#selections[@]} -eq 0 ]]; then
  echo "No items selected. Exiting."
  exit 0
fi

echo ""
echo "=== Linking selected items ==="

for item in "${!selections[@]}"; do
  IFS=':' read -r type name path <<< "$item"
  
  if [[ "$type" == "config" ]]; then
    target="$CONFIG_DIR/$name"
  else
    target="$HOME/$name"
  fi
  
  if [[ -L "$target" ]]; then
    read -rp "$name already exists as a symlink. Override? [y/N] " answer
    case "$answer" in
      [Yy]*) rm -f "$target" ;;
      *) echo "Skipping $name"; continue ;;
    esac
  elif [[ -d "$target" ]]; then
    if [[ "$(ls -A "$target")" ]]; then
      read -rp "$name already exists and is a non-empty directory. Override? [y/N] " answer
      case "$answer" in
        [Yy]*) rm -rf "$target" ;;
        *) echo "Skipping $name"; continue ;;
      esac
    else
      rm -rf "$target"
    fi
  elif [[ -e "$target" ]]; then
    read -rp "$name already exists. Override? [y/N] " answer
    case "$answer" in
      [Yy]*) rm -rf "$target" ;;
      *) echo "Skipping $name"; continue ;;
    esac
  fi
  
  ln -s "$path" "$target"
  echo "Linked $name"
done

echo ""
echo "Done!"
