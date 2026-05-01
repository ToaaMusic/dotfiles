local h = require("helper")

local M = {}

-- [[ Internal: IO & Utils ]]

local function upsert_block(path, new_content, comment_symbol, marker)
  comment_symbol = comment_symbol or "//"
  marker = marker or "generated"

  local text = ""
  local rf = io.open(path, "r")
  if rf then
    text = rf:read("*a")
    rf:close()
  end

  local escaped_cs = comment_symbol:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  local escaped_mk = marker:gsub("([%%%^%$%(%)%.%[%]%*%+%-%?])", "%%%1")
  local start_pat = escaped_cs .. "%s*" .. escaped_mk .. "%s*\n"
  local end_pat = escaped_cs .. "%s*" .. escaped_mk .. "%s*end%s*\n?"

  local s, e = text:find(start_pat)
  if s then
    local s2, e2 = text:find(end_pat, e + 1)
    if not s2 then error("Found start marker but missing end marker in " .. path) end
    text = text:sub(1, s - 1) .. comment_symbol .. " " .. marker .. "\n" ..
           new_content .. "\n" .. comment_symbol .. " " .. marker .. " end\n" ..
           text:sub(e2 + 1)
  else
    if text ~= "" and not text:match("\n$") then text = text .. "\n" end
    text = text .. "\n" .. comment_symbol .. " " .. marker .. "\n" ..
           new_content .. "\n" .. comment_symbol .. " " .. marker .. " end\n"
  end

  local wf = assert(io.open(path, "w"))
  wf:write(text)
  wf:close()
end

-- Minimal local strategy for gradient lifting (keeps write.lua independent of colors.lua)
local function quick_lift(hex, bg, ratio, step)
  if h.get_contrast(hex, bg) >= ratio then return hex end
  local target = h.get_contrast("#000000", bg) >= h.get_contrast("#ffffff", bg) and "#000000" or "#ffffff"
  local current = hex
  for _ = 1, 10 do
    current = h.mix(current, target, step or 0.14)
    if h.get_contrast(current, bg) >= ratio then return current end
  end
  return current
end

-- [[ Writers ]]
local function write_hypr(p)
  local path = os.getenv("HOME") .. "/.config/hypr/hyprmain/colors.g.conf"
  local f = assert(io.open(path, "w"))
  f:write(string.format("$active_border_color = rgba(%sff)\n", p.accent:sub(2)))
  f:write(string.format("$inactive_border_color = 0xff%s\n", p.bg_border:sub(2)))
  f:close()
end

local function write_waybar(p)
  local path = os.getenv("HOME") .. "/.config/waybar/colors.g.css"
  local f = assert(io.open(path, "w"))
  f:write(string.format("@define-color bg %s;\n@define-color bg-elevated %s;\n@define-color bg-hover %s;\n", p.bg, p.bg_elevated, p.bg_hover))
  f:write(string.format("@define-color bg-active %s;\n@define-color bg-border %s;\n@define-color bg-shadow %s;\n\n", p.bg_active, p.bg_border, p.bg_shadow))
  f:write("/* text */\n\n")
  f:write(string.format("@define-color fg %s;\n@define-color fg-hover %s;\n@define-color fg-muted %s;\n@define-color fg-subtle %s;\n@define-color fg-shadow %s;\n\n", p.fg, p.fg_hover, p.fg_muted, p.fg_subtle, p.fg_shadow))
  f:write("/* accents */\n\n")
  f:write(string.format("@define-color accent %s;\n@define-color accent-soft %s;\n@define-color accent-strong %s;\n@define-color accent-fg %s;\n", p.accent, p.accent_soft, p.accent_strong, p.accent_fg))
  f:write(string.format("@define-color a %s;\n", p.accent))
  for i = 1, 6 do f:write(string.format("@define-color a%d %s;\n", i, p.accents[i])) end
  f:close()
end

local function write_kitty(p)
  local path = os.getenv("HOME") .. "/.config/kitty/colors.g.conf"
  local f = assert(io.open(path, "w"))
  f:write("# Generated Kitty Theme\n")
  f:write(string.format("foreground %s\nbackground %s\n", p.fg, p.bg))
  f:write(string.format("selection_foreground %s\nselection_background %s\n", p.accent_fg, p.accent))
  f:write(string.format("cursor %s\ncursor_text_color %s\n", p.accent_strong, p.accent_fg))
  f:write(string.format("url_color %s\nactive_border_color %s\ninactive_border_color %s\nbell_border_color %s\n", p.accent_strong, p.accent_strong, p.bg_border, p.accents[2]))
  f:write("wayland_titlebar_color system\n")
  f:write(string.format("active_tab_foreground %s\nactive_tab_background %s\n", p.accent_fg, p.accent))
  f:write(string.format("inactive_tab_foreground %s\ninactive_tab_background %s\ntab_bar_background %s\n", p.fg_muted, p.bg_elevated, p.bg))
  f:write(string.format("mark1_foreground %s\nmark1_background %s\nmark2_foreground %s\nmark2_background %s\nmark3_foreground %s\nmark3_background %s\n\n", p.accent_fg, p.accent, p.accent_fg, p.accents[2], p.accent_fg, p.accents[3]))
  for i = 0, 7 do
    f:write(string.format("color%d %s\n", i, p.kitty_normal[i + 1]))
    f:write(string.format("color%d %s\n", i + 8, p.kitty_bright[i + 1]))
  end
  local active_template = string.format(
    "{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
    "_" .. p.accent_fg:sub(2),   -- _ffffff
    "_" .. p.bg:sub(2),          -- _04141C
    "_" .. p.accent:sub(2),      -- _5f757b
    "_" .. p.accent_fg:sub(2),   -- _ffffff
    "_" .. p.accent_fg:sub(2),   -- _ffffff
    "_" .. p.bg:sub(2)           -- _04141C
  )

-- 非活动标签模板
  local inactive_template = string.format(
    "{fmt.fg.%s}{fmt.bg.%s}{fmt.fg.%s}{fmt.bg.%s} {title.split()[0]} {fmt.fg.%s}{fmt.bg.%s} ",
    "_" .. p.fg_muted:sub(2),    -- _a0a8ac
    "_" .. p.bg:sub(2),          -- _04141C
    "_" .. p.bg_elevated:sub(2), -- _14242b
    "_" .. p.fg_muted:sub(2),    -- _a0a8ac
    "_" .. p.fg_muted:sub(2),    -- _a0a8ac
    "_" .. p.bg:sub(2)           -- _04141C
  )
  f:write(string.format("active_tab_title_template %q\n", active_template))
  f:write(string.format("tab_title_template %q\n", inactive_template))
  f:close()
end

local function write_cava(p)
  local path = os.getenv("HOME") .. "/.config/cava/themes/colors.g.theme"
  os.execute("mkdir -p " .. path:match("(.*/)"))
  local f = assert(io.open(path, "w"))

  local b = p.dark_mode and quick_lift(h.mix(p.accent, p.fg, 0.60), p.bg, 4.4, 0.14) or quick_lift(h.mix(p.accent, "#ffffff", 0.34), p.bg, 3.6, 0.14)
  local m = p.dark_mode and quick_lift(h.mix(p.accent, p.accents[2], 0.48), p.bg, 3.2, 0.14) or quick_lift(h.mix(p.accent, p.accents[2], 0.55), p.bg, 3.0, 0.14)
  local t = p.dark_mode and quick_lift(h.mix(p.accents[2], p.bg, 0.78), p.bg, 1.35, 0.14) or quick_lift(h.mix(p.accents[2], "#000000", 0.58), p.bg, 2.1, 0.14)

  f:write("[color]\nbackground = default\nforeground = '" .. p.accent .. "'\ngradient = 1\n")
  for i = 1, 8 do
    local ratio = (i - 1) / 7
    local shade = ratio <= 0.5 and h.mix(b, m, ratio / 0.5) or h.mix(m, t, (ratio - 0.5) / 0.5)
    f:write(string.format("gradient_color_%d = '%s'\n", i, quick_lift(shade, p.bg, p.dark_mode and 1.7 or 2.1, 0.12)))
  end
  f:close()
end

local function write_rofi(p)
  local path = os.getenv("HOME") .. "/.config/rofi/colors.g.rasi"
  local f = assert(io.open(path, "w"))
  f:write("* {\n")
  f:write(string.format("    bg: %s;\n    fg: %s;\n    bg-lighter: %s;\n    bg-active: %s;\n    border: %s;\n    accent: %s;\n    accent-fg: %s;\n", p.bg, p.fg, p.bg_hover, p.bg_active, p.bg_border, p.accent, p.accent_fg))
  for i = 1, 6 do f:write(string.format("    a%d: %s;\n", i, p.accents[i])) end
  f:write("}\n")
  f:close()
end

local function write_fcitx5(p)
  local path = os.getenv("HOME") .. "/.local/share/fcitx5/themes/auto-gen/theme.conf"
  os.execute("mkdir -p " .. path:match("(.*/)"))
  local f = assert(io.open(path, "w"))

  local asset_theme = p.dark_mode and "default-dark" or "default"
  local asset_root = "/usr/share/fcitx5/themes/" .. asset_theme
  local normal_color = p.fg
  local highlight_candidate_color = p.accent_fg
  local panel_highlight_bg = p.accent
  local panel_highlight = p.bg_active
  local menu_highlight = p.bg_active
  local separator = p.bg_border

  f:write("[Metadata]\n")
  f:write("Name=Auto Gen\n")
  f:write("Version=1\n")
  f:write("Author=wallpaper gen.lua\n")
  f:write("Description=Auto generated theme\n")
  f:write("ScaleWithDPI=True\n\n")

  f:write("[InputPanel]\n")
  f:write(string.format("NormalColor=%s\n", normal_color))
  f:write(string.format("HighlightCandidateColor=%s\n", highlight_candidate_color))
  f:write(string.format("HighlightColor=%s\n", highlight_candidate_color))
  f:write(string.format("HighlightBackgroundColor=%s\n", panel_highlight_bg))
  f:write("PageButtonAlignment=Last Candidate\n\n")

  f:write("[InputPanel/TextMargin]\nLeft=5\nRight=5\nTop=5\nBottom=5\n\n")
  f:write("[InputPanel/ContentMargin]\nLeft=2\nRight=2\nTop=2\nBottom=2\n\n")

  f:write("[InputPanel/Background]\n")
  f:write(string.format("Color=%s\n", p.bg))
  f:write(string.format("BorderColor=%s\n", p.bg_border))
  f:write("BorderWidth=2\n\n")

  f:write("[InputPanel/Background/Margin]\nLeft=2\nRight=2\nTop=2\nBottom=2\n\n")

  f:write("[InputPanel/Highlight]\n")
  f:write(string.format("Color=%s\n\n", panel_highlight))

  f:write("[InputPanel/Highlight/Margin]\nLeft=5\nRight=5\nTop=5\nBottom=5\n\n")

  f:write("[InputPanel/PrevPage]\n")
  f:write(string.format("Image=%s/prev.png\n\n", asset_root))
  f:write("[InputPanel/PrevPage/ClickMargin]\nLeft=5\nRight=5\nTop=4\nBottom=4\n\n")

  f:write("[InputPanel/NextPage]\n")
  f:write(string.format("Image=%s/next.png\n\n", asset_root))
  f:write("[InputPanel/NextPage/ClickMargin]\nLeft=5\nRight=5\nTop=4\nBottom=4\n\n")

  f:write("[Menu]\n")
  f:write(string.format("NormalColor=%s\n", normal_color))
  f:write(string.format("HighlightCandidateColor=%s\n\n", highlight_candidate_color))

  f:write("[Menu/Background]\n")
  f:write(string.format("Color=%s\n", p.bg))
  f:write(string.format("BorderColor=%s\n", p.bg_border))
  f:write("BorderWidth=2\n\n")

  f:write("[Menu/Background/Margin]\nLeft=2\nRight=2\nTop=2\nBottom=2\n\n")
  f:write("[Menu/ContentMargin]\nLeft=2\nRight=2\nTop=2\nBottom=2\n\n")

  f:write("[Menu/CheckBox]\n")
  f:write(string.format("Image=%s/radio.png\n\n", asset_root))
  f:write("[Menu/SubMenu]\n")
  f:write(string.format("Image=%s/arrow.png\n\n", asset_root))

  f:write("[Menu/Highlight]\n")
  f:write(string.format("Color=%s\n\n", menu_highlight))

  f:write("[Menu/Highlight/Margin]\nLeft=5\nRight=5\nTop=5\nBottom=5\n\n")

  f:write("[Menu/Separator]\n")
  f:write(string.format("Color=%s\n\n", separator))

  f:write("[Menu/TextMargin]\nLeft=5\nRight=5\nTop=5\nBottom=5\n\n")

  f:write("[AccentColorField]\n")
  f:write("0=Input Panel Border\n")
  f:write("1=Input Panel Highlight Candidate Background\n")
  f:write("2=Input Panel Highlight\n")
  f:write("3=Menu Border\n")
  f:write("4=Menu Separator\n")
  f:write("5=Menu Selected Item Background\n")
  f:close()
end

local function write_nvim(p)
  local syntax_keys = {
    "keyword",
    "keyword_flow",
    "keyword_return",
    "string",
    "number",
    "type",
    "func",
    "func_call",
    "variable",
    "constant",
    "macro",
    "builtin",
    "property",
    "parameter",
    "operator",
    "punctuation",
    "namespace",
  }
  local path = os.getenv("HOME") .. "/.config/nvim/lua/colors/g.lua"
  os.execute("mkdir -p " .. path:match("(.*/)"))
  local f = assert(io.open(path, "w"))
  f:write("-- Generated by wallpaper gen.lua\n-- Do not edit manually!\n\nreturn {\n")
  f:write(string.format("  dark_mode = %s,\n", p.dark_mode and "true" or "false"))
  f:write(string.format("  bg = %q, fg = %q,\n  bg_elevated = %q, bg_hover = %q, bg_active = %q, bg_border = %q, bg_shadow = %q,\n", p.bg, p.fg, p.bg_elevated, p.bg_hover, p.bg_active, p.bg_border, p.bg_shadow))
  f:write(string.format("  fg_muted = %q, fg_subtle = %q, fg_hover = %q, fg_shadow = %q,\n", p.fg_muted, p.fg_subtle, p.fg_hover, p.fg_shadow))
  f:write(string.format("  accent = %q, accent_soft = %q, accent_strong = %q, accent_fg = %q,\n", p.accent, p.accent_soft, p.accent_strong, p.accent_fg))
  f:write("  accents = {\n")
  for _, a in ipairs(p.accents) do f:write(string.format("    %q,\n", a)) end
  f:write("  },\n  syntax = {\n")
  for _, key in ipairs(syntax_keys) do
    f:write(string.format("    %s = %q,\n", key, p.syntax[key]))
  end
  f:write("  },\n  kitty_normal = {")
  for i = 1, 8 do f:write(string.format("%q%s", p.kitty_normal[i], i < 8 and ", " or "")) end
  f:write("},\n  kitty_bright = {")
  for i = 1, 8 do f:write(string.format("%q%s", p.kitty_bright[i], i < 8 and ", " or "")) end
  f:write("},\n}\n")
  f:close()
end

-- [[ Public ]]

function M.preview(p)
  local dot = " "
  for _, hex in ipairs(p.preview) do
    local r, g, b = h.to_rgb(hex)
    io.write(string.format("\27[38;2;%d;%d;%dm%s", r, g, b, dot))
  end
  io.write("\27[0m\n")
  for _, hex in ipairs(p.preview) do print(hex) end
end

function M.apply(p)
  write_hypr(p)
  write_waybar(p)
  write_kitty(p)
  write_cava(p)
  write_rofi(p)
  write_fcitx5(p)
  write_nvim(p)

  -- Dunst
  local dunst_path = os.getenv("HOME") .. "/.config/dunst/dunstrc"
  local dunst_cont = string.format("[fullscreen]\n  background = %q\n  foreground = %q\n", p.bg, p.fg)
  upsert_block(dunst_path, dunst_cont, "#")
  os.execute("dunstctl reload")
  os.execute("pkill fcitx5; fcitx5 -d")
end

return M
