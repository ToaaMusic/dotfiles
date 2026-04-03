#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_TARGET_DIR="$DOTFILES_DIR/config"
HOME_TARGET_DIR="$DOTFILES_DIR/home"
CONFIG_DIR="$HOME/.config"

mkdir -p "$CONFIG_DIR"

for dir in "$CONFIG_TARGET_DIR"/*/; do
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

for file in "$HOME_TARGET_DIR"/.*; do
  name="$(basename "$file")"

  # 跳过 . 和 ..
  [[ "$name" == "." || "$name" == ".." ]] && continue

  target="$HOME/$name"

  if [[ -L "$target" ]]; then
    read -rp "$name already exists as a symlink. Override? [y/N] " answer
    [[ "$answer" =~ ^[Yy] ]] || { echo "Skipping $name"; continue; }
    rm -f "$target"

  elif [[ -e "$target" ]]; then
    read -rp "$name already exists. Override? [y/N] " answer
    [[ "$answer" =~ ^[Yy] ]] || { echo "Skipping $name"; continue; }
    rm -rf "$target"
  fi

  ln -s "$file" "$target"
  echo "Linked home/$name"
done

echo "Generating Rofi desktop entry..."

DESKTOP_ENTRY_DIR="$HOME/.local/share/applications"
mkdir -p "$DESKTOP_ENTRY_DIR"

cat > "$DESKTOP_ENTRY_DIR/toaam-dotfiles.desktop" <<'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Zed: Edit Dotfiles
Comment=Open Dotfiles project in Zed
Exec=zsh -lc 'zeditor "$TOAAM_DOTFILES"'
Icon=zed
Terminal=false
Categories=Development;TextEditor;
Keywords=dotfiles;config;zed;
EOF

chmod +x "$DESKTOP_ENTRY_DIR/toaam-dotfiles.desktop"
