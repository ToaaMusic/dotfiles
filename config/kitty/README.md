# Kitty Config Guide

This document summarizes the useful parts of the original `kitty.conf` template and the options currently kept in this repo.

## Current Structure

The live config is now comment-free, but it preserves the active settings that were present in the old file:

- Theme includes:
  - `include default-colors.conf`
  - `include colors.g.conf`
- Font setup:
  - `font_family`
  - `bold_font`
  - `italic_font`
  - `bold_italic_font`
  - `font_size`
- Glyph fallback:
  - `symbol_map` for CJK and Nerd Font glyphs
- Window layout:
  - `remember_window_size`
  - `initial_window_width`
  - `initial_window_height`
  - `window_border_width`
  - `draw_minimal_borders`
  - `window_padding_width`
- Tab bar:
  - `tab_bar_margin_width`
  - `tab_bar_margin_height`
  - `tab_bar_style`
  - `tab_bar_min_tabs`
  - `tab_separator`
  - `tab_title_template`
  - `active_tab_title_template`
- Integration:
  - `allow_remote_control`
  - `listen_on`
  - `clipboard_control`
  - `shell_integration`
- Keymaps:
  - clipboard
  - scrolling
  - window management
  - tab management
  - layout switching
  - font-size control

## Option Categories

### 1. Theme And Colors

Useful options:

- `include`: split theme files from the main config.
- `foreground`, `background`: base terminal colors.
- `selection_foreground`, `selection_background`: selection colors.
- `cursor`, `cursor_text_color`: cursor visuals.
- `active_tab_*`, `inactive_tab_*`, `tab_bar_background`: tab colors.
- `color0` to `color15`: ANSI terminal palette.
- `active_border_color`, `inactive_border_color`, `bell_border_color`: window border colors.

In this repo, these are mostly delegated to generated files:

- [default-colors.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/default-colors.conf)
- [colors.g.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/colors.g.conf)

### 2. Fonts And Glyphs

Useful options:

- `font_family`, `bold_font`, `italic_font`, `bold_italic_font`: select the four main font faces.
- `font_size`: terminal font size.
- `adjust_line_height`, `adjust_column_width`: tune spacing if a font feels too tight or too wide.
- `symbol_map`: map some Unicode ranges to a different font.
- `narrow_symbols`: force some wide symbols to occupy fewer cells.
- `font_features`: enable or disable OpenType features.
- `modify_font`: tweak underline position, baseline, thickness, cell geometry.

Your current config uses:

- JuliaMono for code text
- LXGW WenKai for CJK
- Symbols Nerd Font Mono for icon glyphs

### 3. Cursor

Useful options:

- `cursor_shape`: `block`, `beam`, `underline`
- `cursor_blink_interval`
- `cursor_stop_blinking_after`
- `cursor_beam_thickness`
- `cursor_underline_thickness`
- `cursor_trail`

You currently only keep `cursor_trail 3`. The rest were default/template values and removed.

### 4. Scrollback

Useful options:

- `scrollback_lines`: in-memory history length
- `scrollback_pager`: external pager for scrollback
- `scrollback_pager_history_size`: extra history just for pager mode

You keep `scrollback_lines 2000`.

### 5. Mouse, URL, Selection

Common options from the template:

- `open_url_with`
- `detect_urls`
- `url_style`
- `copy_on_select`
- `select_by_word_characters`
- `click_interval`

These were removed because the file only contained default behavior, not custom choices.

### 6. Performance And Rendering

Common options from the template:

- `repaint_delay`
- `sync_to_monitor`
- `background_opacity`
- `resize_debounce_time`
- `resize_draw_strategy`
- `inactive_text_alpha`

These matter when tuning smoothness, opacity, and resize behavior.

### 7. Bell And Notifications

Useful options:

- `enable_audio_bell`
- `visual_bell_duration`
- `window_alert_on_bell`
- `bell_on_tab`
- `command_on_bell`
- `bell_path`

The old file had these mostly as template/default settings, so they were removed from the live config.

### 8. Window Layout And Appearance

Useful options:

- `remember_window_size`
- `initial_window_width`
- `initial_window_height`
- `enabled_layouts`
- `window_resize_step_cells`
- `window_resize_step_lines`
- `window_border_width`
- `draw_minimal_borders`
- `window_margin_width`
- `single_window_margin_width`
- `window_padding_width`
- `hide_window_decorations`

You currently keep only the ones that clearly affect your layout and spacing.

### 9. Tab Bar

Useful options:

- `tab_bar_style`
- `tab_bar_edge`
- `tab_bar_min_tabs`
- `tab_separator`
- `tab_title_template`
- `active_tab_title_template`
- `tab_bar_margin_width`
- `tab_bar_margin_height`
- `tab_bar_background`

Your tab templates are customized and worth keeping. They are the main non-default visual customization in your kitty UI.

### 10. Remote Control And Session

Useful options:

- `allow_remote_control`
- `listen_on`
- `remote_control_password`
- `startup_session`
- `watcher`
- `env`
- `exe_search_path`

Important note:

- `allow_remote_control yes` is the most permissive mode.
- If you only need socket-based control, `socket-only` is safer.
- `listen_on unix:/tmp/kitty` creates a fixed socket path. That is convenient, but worth reviewing from a security perspective.

### 11. Clipboard And Shell Integration

Useful options:

- `clipboard_control`
- `clipboard_max_size`
- `allow_hyperlinks`
- `shell_integration`

Your current clipboard policy is conservative on reads and normal on writes, which is reasonable.

### 12. Keymaps

There are two layers to think about:

- Built-in kitty defaults
- Your custom `map` overrides/additions

Useful keymap-related options:

- `kitty_mod`: alias used by many default mappings
- `clear_all_shortcuts`: wipe defaults before redefining everything
- `map`: bind a key to an action
- `action_alias`: create aliases for complex actions

The old file repeated a large block of shortcut definitions from kitty's sample config. To avoid accidental behavior drift, the active mappings from the old file are still preserved in the live config. Only the tutorial comments and commented examples were removed.

## What Was Removed

The old file mixed together:

- your real settings
- official sample defaults
- large tutorial comments
- commented alternative fonts
- many default key bindings copied from the template

These were removed from [kitty.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/kitty.conf) to keep the live file maintainable, but the previously active settings were kept.

## Practical Learning Path

If you want to learn kitty config without getting overwhelmed, focus in this order:

1. Fonts:
   `font_family`, `font_size`, `symbol_map`
2. Theme:
   `include`, `foreground`, `background`, `color0..15`
3. Layout:
   `window_padding_width`, `window_border_width`, `remember_window_size`
4. Tabs:
   `tab_bar_style`, `tab_title_template`
5. Workflow:
   `shell_integration`, `clipboard_control`, `map`
6. Advanced:
   `allow_remote_control`, `watcher`, `startup_session`, `action_alias`

## Files To Read Together

- Live config: [kitty.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/kitty.conf)
- Base colors: [default-colors.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/default-colors.conf)
- Generated colors: [colors.g.conf](/home/ToaaM/repos/linux/dotfiles/config/kitty/colors.g.conf)
