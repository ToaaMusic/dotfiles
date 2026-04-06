vim.opt.termguicolors = true
vim.opt.fillchars:append({ eob = " " })

local colors = require("colors.g")
local hl = vim.api.nvim_set_hl

local bg_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "EndOfBuffer",
  "MsgArea",
  "FloatBorder",
  "NormalFloat",
}

local function set_bg_transparent()
    for _, group in ipairs(bg_groups) do
        hl(0, group, { bg = "none" })
    end
    hl(0, "EndOfBuffer", { fg = "NONE", bg = "NONE" })
end

-- run

-- ==================== 基础 UI ====================
hl(0, "Normal",          { bg = colors.bg, fg = colors.fg })
hl(0, "NormalFloat",     { bg = colors.bg_elevated, fg = colors.fg })
hl(0, "NormalNC",        { bg = colors.bg, fg = colors.fg_muted })

hl(0, "Comment",         { fg = colors.fg_muted, italic = true })
hl(0, "LineNr",          { fg = colors.fg_subtle })
hl(0, "CursorLineNr",    { fg = colors.fg_hover, bold = true })
hl(0, "CursorLine",      { bg = colors.bg_hover })
hl(0, "CursorColumn",    { bg = colors.bg_hover })

hl(0, "Visual",          { bg = colors.bg_active })
hl(0, "Search",          { bg = colors.accent_soft, fg = colors.bg })
hl(0, "IncSearch",       { bg = colors.accent_strong, fg = colors.bg })

hl(0, "StatusLine",      { bg = colors.bg_active, fg = colors.fg })
hl(0, "StatusLineNC",    { bg = colors.bg_elevated, fg = colors.fg_muted })
hl(0, "WinSeparator",    { fg = colors.bg_border })
hl(0, "VertSplit",       { link = "WinSeparator" })

hl(0, "TabLine",         { bg = colors.bg_elevated, fg = colors.fg_muted })
hl(0, "TabLineSel",      { bg = colors.accent, fg = colors.accent_fg, bold = true })
hl(0, "TabLineFill",     { bg = colors.bg })

hl(0, "Pmenu",           { bg = colors.bg_elevated, fg = colors.fg })
hl(0, "PmenuSel",        { bg = colors.accent, fg = colors.accent_fg })
hl(0, "PmenuThumb",      { bg = colors.accent_strong })

hl(0, "Folded",          { bg = colors.bg_hover, fg = colors.fg_muted })
hl(0, "FoldColumn",      { fg = colors.fg_subtle })

-- ==================== Syntax & Treesitter ====================
hl(0, "String",          { fg = colors.accents[2] })
hl(0, "Character",       { fg = colors.accents[2] })
hl(0, "Number",          { fg = colors.accents[3] })
hl(0, "Boolean",         { fg = colors.accents[3] })
hl(0, "Float",           { fg = colors.accents[3] })

hl(0, "Function",        { fg = colors.accent_strong })
hl(0, "Identifier",      { fg = colors.fg })
hl(0, "Keyword",         { fg = colors.accent })
hl(0, "Operator",        { fg = colors.accent_soft })
hl(0, "Statement",       { fg = colors.accent })
hl(0, "Conditional",     { fg = colors.accent })
hl(0, "Repeat",          { fg = colors.accent })
hl(0, "Label",           { fg = colors.accent_strong })

hl(0, "Type",            { fg = colors.accents[4] })
hl(0, "StorageClass",    { fg = colors.accents[4] })
hl(0, "Structure",       { fg = colors.accents[4] })
hl(0, "Typedef",         { fg = colors.accents[4] })

hl(0, "Constant",        { fg = colors.accents[5] })
hl(0, "PreProc",         { fg = colors.accents[6] })

-- Treesitter 现代 capture groups（推荐）
hl(0, "@comment",        { link = "Comment" })
hl(0, "@string",         { link = "String" })
hl(0, "@number",         { link = "Number" })
hl(0, "@function",       { link = "Function" })
hl(0, "@function.call",  { fg = colors.accent_strong })
hl(0, "@keyword",        { link = "Keyword" })
hl(0, "@keyword.return", { fg = colors.accent_strong, italic = true })
hl(0, "@variable",       { fg = colors.fg })
hl(0, "@variable.builtin",{ fg = colors.accents[1] })
hl(0, "@type",           { link = "Type" })
hl(0, "@type.builtin",   { fg = colors.accents[4] })
hl(0, "@property",       { fg = colors.fg_hover })
hl(0, "@parameter",      { fg = colors.fg_hover })
hl(0, "@operator",       { link = "Operator" })

-- ==================== Diagnostics & LSP ====================
hl(0, "DiagnosticError", { fg = colors.accents[1] })
hl(0, "DiagnosticWarn",  { fg = colors.accents[3] })
hl(0, "DiagnosticInfo",  { fg = colors.accents[5] })
hl(0, "DiagnosticHint",  { fg = colors.accents[6] })

hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.accents[1] })
hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = colors.accents[3] })

hl(0, "LspSignatureActiveParameter", { bg = colors.bg_hover })

-- ==================== 常用插件 ====================
-- Telescope
hl(0, "TelescopeNormal",         { bg = colors.bg_elevated })
hl(0, "TelescopeBorder",         { fg = colors.bg_border })
hl(0, "TelescopePromptNormal",   { bg = colors.bg_active })
hl(0, "TelescopeSelection",      { bg = colors.bg_hover, fg = colors.accent_strong })

-- tree
hl(0, "NeoTreeIndentMarker", { fg = colors.bg_border, bg = "none" })
-- hl(0, "NeoTreeNormal",     { bg = colors.bg_elevated, fg = colors.fg })
-- hl(0, "NeoTreeNormalNC",   { bg = colors.bg_elevated, fg = colors.fg_muted })
-- hl(0, "NeoTreeExpander",     { fg = colors.accent_soft, bg = colors.bg_elevated })
-- hl(0, "NeoTreeDirectoryName",      { fg = colors.accent, bg = colors.bg_elevated })
-- hl(0, "NeoTreeDirectoryIcon",      { fg = colors.accent, bg = colors.bg_elevated })
-- hl(0, "NeoTreeOpenedFolderName",   { fg = colors.accent_strong, bg = colors.bg_elevated })
-- hl(0, "NeoTreeWinSeparator", { fg = colors.bg_border, bg = colors.bg_elevated })
--
hl(0, "NeoTreeGitIgnored",      { fg = colors.fg_subtle })
-- hl(0, "NeoTreeGitUntracked",    { fg = colors.accents[2] })
-- hl(0, "NeoTreeGitModified",     { fg = colors.accents[4] })
-- hl(0, "NeoTreeGitAdded",        { fg = colors.accents[2] })

-- WhichKey
hl(0, "WhichKey",                { fg = colors.accent })
hl(0, "WhichKeyGroup",           { fg = colors.accent_strong })

-- CMP / completion
hl(0, "CmpItemAbbrMatch",        { fg = colors.accent_strong })
hl(0, "CmpItemKind",             { fg = colors.accents[4] })

-- GitSigns
hl(0, "GitSignsAdd",             { fg = colors.accents[2] })
hl(0, "GitSignsChange",          { fg = colors.accents[4] })
hl(0, "GitSignsDelete",          { fg = colors.accents[1] })

-- ==================== 其他常用 ====================
hl(0, "Title",                   { fg = colors.accent_strong, bold = true })
hl(0, "ErrorMsg",                { fg = colors.accents[1] })
hl(0, "WarningMsg",              { fg = colors.accents[3] })
hl(0, "MoreMsg",                 { fg = colors.accents[5] })

hl(0, "MatchParen",              { bg = colors.bg_hover, bold = true })
hl(0, "Todo",                    { bg = colors.accent_soft, fg = colors.bg, bold = true })

set_bg_transparent()
