vim.opt.termguicolors = true
vim.opt.fillchars:append({ eob = " " })

local colors = require("colors.g")
local hl = vim.api.nvim_set_hl
local syntax = vim.tbl_extend("force", {
  keyword = colors.accent,
  keyword_flow = colors.accent,
  keyword_return = colors.accent_strong,
  string = colors.accents[2],
  number = colors.accents[3],
  type = colors.accents[4],
  func = colors.accent_strong,
  func_call = colors.accent_strong,
  variable = colors.fg_hover,
  constant = colors.accents[5],
  macro = colors.accents[6],
  builtin = colors.accents[1],
  property = colors.fg_hover,
  parameter = colors.fg_hover,
  operator = colors.accent_soft,
  punctuation = colors.fg_muted,
  namespace = colors.accents[4],
}, colors.syntax or {})

local function apply_group_map(map)
  for group, spec in pairs(map) do
    local value = spec
    if type(spec) == "string" then
      value = { fg = spec }
    end
    hl(0, group, value)
  end
end

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

hl(0, "Comment",         { fg = colors.bg_border, italic = true })
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
hl(0, "PmenuKind",       { bg = "none", fg = syntax.type })
hl(0, "PmenuExtra",      { bg = "none", fg = colors.fg_muted })
hl(0, "BlinkCmpKind",    { bg = "none", fg = syntax.type })
hl(0, "BlinkCmpKindText",{ bg = "none", fg = syntax.type })
hl(0, "BlinkCmpKindMethod", { bg = "none", fg = syntax.func })
hl(0, "BlinkCmpKindFunction", { bg = "none", fg = syntax.func })
hl(0, "BlinkCmpKindVariable", { bg = "none", fg = syntax.variable })
hl(0, "BlinkCmpKindClass", { bg = "none", fg = syntax.type })
hl(0, "BlinkCmpKindInterface", { bg = "none", fg = syntax.type })
hl(0, "BlinkCmpKindModule", { bg = "none", fg = syntax.namespace })
hl(0, "BlinkCmpKindProperty", { bg = "none", fg = syntax.property })
hl(0, "BlinkCmpKindField", { bg = "none", fg = syntax.property })
hl(0, "BlinkCmpKindKeyword", { bg = "none", fg = syntax.keyword })
hl(0, "BlinkCmpKindSnippet", { bg = "none", fg = syntax.constant })
hl(0, "BlinkCmpKindConstant", { bg = "none", fg = syntax.constant })
hl(0, "BlinkCmpMenu",    { bg = "none", fg = colors.fg })
hl(0, "BlinkCmpMenuBorder", { fg = colors.bg_border, bg = "none" })
hl(0, "BlinkCmpDoc",     { bg = "none", fg = colors.fg })
hl(0, "BlinkCmpDocBorder", { fg = colors.bg_border, bg = "none" })
hl(0, "BlinkCmpSignatureHelp", { bg = "none", fg = colors.fg })
hl(0, "BlinkCmpSignatureHelpBorder", { fg = colors.bg_border, bg = "none" })

hl(0, "Folded",          { bg = colors.bg_hover, fg = colors.fg_muted })
hl(0, "FoldColumn",      { fg = colors.fg_subtle })

-- ==================== Syntax & Treesitter ====================
hl(0, "String",          { fg = syntax.string })
hl(0, "Character",       { fg = syntax.string })
hl(0, "Number",          { fg = syntax.number })
hl(0, "Float",           { fg = syntax.number })

hl(0, "Function",        { fg = syntax.func })
hl(0, "Identifier",      { fg = syntax.variable })
hl(0, "Keyword",         { fg = syntax.keyword })
hl(0, "Operator",        { fg = syntax.operator })
hl(0, "Statement",       { fg = syntax.keyword_flow })
hl(0, "Conditional",     { fg = syntax.keyword_flow })
hl(0, "Repeat",          { fg = syntax.keyword_flow })
hl(0, "Exception",       { fg = syntax.keyword_return })
hl(0, "Label",           { fg = syntax.namespace })

hl(0, "Type",            { fg = syntax.type })
hl(0, "StorageClass",    { fg = syntax.type })
hl(0, "Structure",       { fg = syntax.type })
hl(0, "Typedef",         { fg = syntax.type })

hl(0, "Constant",        { fg = syntax.constant })
hl(0, "Boolean",         { fg = syntax.builtin })
hl(0, "PreProc",         { fg = syntax.macro })
hl(0, "Include",         { fg = syntax.macro })
hl(0, "Define",          { fg = syntax.macro })
hl(0, "PreCondit",       { fg = syntax.macro })
hl(0, "Macro",           { fg = syntax.macro })
hl(0, "Special",         { fg = syntax.builtin })
hl(0, "SpecialChar",     { fg = syntax.constant })
hl(0, "SpecialComment",  { fg = colors.fg_subtle, italic = true })
hl(0, "Tag",             { fg = syntax.type })
hl(0, "Delimiter",       { fg = syntax.punctuation })
hl(0, "Underlined",      { underline = true })
hl(0, "Ignore",          { fg = colors.fg_subtle })
hl(0, "Error",           { fg = colors.accents[1], bold = true })
hl(0, "DiffAdd",         { fg = colors.accents[2] })
hl(0, "DiffChange",      { fg = colors.accents[4] })
hl(0, "DiffDelete",      { fg = colors.accents[1] })
hl(0, "DiffText",        { fg = colors.accents[5] })
hl(0, "Added",           { fg = colors.accents[2] })
hl(0, "Changed",         { fg = colors.accents[4] })
hl(0, "Removed",         { fg = colors.accents[1] })

-- Treesitter 现代 capture groups（推荐）
hl(0, "@comment",        { link = "Comment" })
hl(0, "@comment.documentation", { link = "Comment" })
hl(0, "@string",         { link = "String" })
hl(0, "@string.documentation", { link = "String" })
hl(0, "@string.regexp",  { fg = syntax.constant })
hl(0, "@string.escape",  { fg = syntax.constant })
hl(0, "@string.special", { fg = syntax.builtin })
hl(0, "@string.special.symbol", { fg = syntax.builtin })
hl(0, "@string.special.path", { fg = syntax.namespace })
hl(0, "@string.special.url", { fg = syntax.namespace, underline = true })
hl(0, "@number",         { link = "Number" })
hl(0, "@boolean",        { fg = syntax.builtin })
hl(0, "@constant",       { link = "Constant" })
hl(0, "@constant.builtin", { fg = syntax.builtin })
hl(0, "@constant.macro", { fg = syntax.macro })
hl(0, "@module",         { fg = syntax.namespace })
hl(0, "@module.builtin", { fg = syntax.namespace })
hl(0, "@label",          { fg = syntax.namespace })
hl(0, "@function",       { link = "Function" })
hl(0, "@function.call",  { fg = syntax.func_call })
hl(0, "@function.builtin", { fg = syntax.builtin })
hl(0, "@method",         { fg = syntax.func })
hl(0, "@method.call",    { fg = syntax.func_call })
hl(0, "@constructor",    { fg = syntax.type })
hl(0, "@keyword",        { link = "Keyword" })
hl(0, "@keyword.conditional", { fg = syntax.keyword_flow })
hl(0, "@keyword.repeat", { fg = syntax.keyword_flow })
hl(0, "@keyword.function", { fg = syntax.keyword_flow })
hl(0, "@keyword.import", { fg = syntax.macro })
hl(0, "@keyword.operator", { fg = syntax.operator })
hl(0, "@keyword.exception", { fg = syntax.keyword_return })
hl(0, "@keyword.return", { fg = syntax.keyword_return, italic = true })
hl(0, "@variable",       { fg = syntax.variable })
hl(0, "@variable.member",{ fg = syntax.property })
hl(0, "@variable.parameter",{ fg = syntax.parameter })
hl(0, "@variable.parameter.builtin",{ fg = syntax.builtin })
hl(0, "@variable.builtin",{ fg = syntax.builtin })
hl(0, "@type",           { link = "Type" })
hl(0, "@type.builtin",   { fg = syntax.builtin })
hl(0, "@type.definition", { fg = syntax.namespace })
hl(0, "@namespace",      { fg = syntax.namespace })
hl(0, "@property",       { fg = syntax.property })
hl(0, "@field",          { fg = syntax.property })
hl(0, "@parameter",      { fg = syntax.parameter })
hl(0, "@operator",       { link = "Operator" })
hl(0, "@punctuation",    { fg = syntax.punctuation })
hl(0, "@punctuation.bracket", { fg = syntax.punctuation })
hl(0, "@punctuation.delimiter", { fg = syntax.punctuation })
hl(0, "@punctuation.special", { fg = syntax.builtin })
hl(0, "@markup",         { fg = colors.fg })
hl(0, "@markup.strong",  { fg = colors.fg, bold = true })
hl(0, "@markup.italic",  { fg = colors.fg, italic = true })
hl(0, "@markup.strikethrough", { fg = colors.fg, strikethrough = true })
hl(0, "@markup.underline", { fg = colors.fg, underline = true })
hl(0, "@markup.quote",   { fg = colors.fg_subtle, italic = true })
hl(0, "@markup.math",    { fg = syntax.constant })
hl(0, "@markup.link",    { fg = syntax.namespace, underline = true })
hl(0, "@markup.link.label", { fg = syntax.namespace })
hl(0, "@markup.link.url", { fg = syntax.namespace, underline = true })
hl(0, "@markup.raw",     { fg = syntax.builtin })
hl(0, "@markup.raw.block", { fg = syntax.builtin })
hl(0, "@markup.list",    { fg = syntax.keyword })
hl(0, "@markup.list.checked", { fg = syntax.keyword })
hl(0, "@markup.list.unchecked", { fg = syntax.keyword })
hl(0, "@tag",            { fg = syntax.type })
hl(0, "@tag.builtin",    { fg = syntax.type })
hl(0, "@tag.attribute",  { fg = syntax.property })
hl(0, "@tag.delimiter",   { fg = syntax.punctuation })
hl(0, "@diff.plus",      { fg = colors.accents[2] })
hl(0, "@diff.minus",     { fg = colors.accents[1] })
hl(0, "@diff.delta",     { fg = colors.accents[4] })

-- ==================== Diagnostics & LSP ====================
hl(0, "DiagnosticError", { fg = colors.accents[1] })
hl(0, "DiagnosticWarn",  { fg = colors.accents[3] })
hl(0, "DiagnosticInfo",  { fg = colors.accents[5] })
hl(0, "DiagnosticHint",  { fg = colors.accents[6] })

hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.accents[1] })
hl(0, "DiagnosticUnderlineWarn",  { undercurl = true, sp = colors.accents[3] })

hl(0, "LspSignatureActiveParameter", { bg = colors.bg_hover })

apply_group_map({
  ["@lsp.type.class"] = syntax.type,
  ["@lsp.type.enum"] = syntax.type,
  ["@lsp.type.enumMember"] = syntax.constant,
  ["@lsp.type.event"] = syntax.constant,
  ["@lsp.type.function"] = syntax.func,
  ["@lsp.type.interface"] = syntax.type,
  ["@lsp.type.keyword"] = syntax.keyword,
  ["@lsp.type.macro"] = syntax.macro,
  ["@lsp.type.method"] = syntax.func,
  ["@lsp.type.namespace"] = syntax.namespace,
  ["@lsp.type.number"] = syntax.number,
  ["@lsp.type.operator"] = syntax.operator,
  ["@lsp.type.parameter"] = syntax.parameter,
  ["@lsp.type.property"] = syntax.property,
  ["@lsp.type.boolean"] = syntax.builtin,
  ["@lsp.type.constant"] = syntax.constant,
  ["@lsp.type.regexp"] = syntax.constant,
  ["@lsp.type.string"] = syntax.string,
  ["@lsp.type.struct"] = syntax.type,
  ["@lsp.type.type"] = syntax.type,
  ["@lsp.type.typeParameter"] = syntax.type,
  ["@lsp.type.variable"] = syntax.variable,
  ["@lsp.type.decorator"] = syntax.macro,
  ["@lsp.type.modifier"] = syntax.keyword,
})
hl(0, "@lsp.type.comment", { link = "Comment" })
hl(0, "@lsp.mod.deprecated", { fg = colors.fg_subtle, strikethrough = true })

-- ==================== 常用插件 ====================
-- Telescope
hl(0, "TelescopeNormal",         { bg = colors.bg_elevated })
hl(0, "TelescopeBorder",         { fg = colors.bg_border })
hl(0, "TelescopePromptNormal",   { bg = colors.bg_active })
hl(0, "TelescopeSelection",      { bg = colors.bg_hover, fg = colors.accent_strong })

-- tree
hl(0, "NeoTreeNormal",          { bg = "none", fg = colors.fg })
hl(0, "NeoTreeNormalNC",        { bg = "none", fg = colors.fg_muted })
hl(0, "NeoTreeFloatBorder",     { fg = colors.bg_border, bg = "none" })
hl(0, "NeoTreeWinSeparator",    { fg = colors.bg_border, bg = "none" })
hl(0, "NeoTreeTabActive",       { fg = colors.fg, bg = "none" })
hl(0, "NeoTreeTabInactive",     { fg = colors.fg_muted, bg = "none" })
hl(0, "NeoTreeTabSeparatorActive",   { fg = "none", bg = "none" })
hl(0, "NeoTreeTabSeparatorInactive", { fg = "none", bg = "none" })
hl(0, "NeoTreeRootName",        { fg = colors.fg, bold = true })
hl(0, "NeoTreeIndentMarker",    { fg = colors.bg_border, bg = "none" })
hl(0, "NeoTreeExpander",        { fg = syntax.punctuation, bg = "none" })
hl(0, "NeoTreeDirectoryName",   { fg = syntax.namespace })
hl(0, "NeoTreeDirectoryIcon",   { fg = syntax.namespace })
hl(0, "NeoTreeOpenedFolderName", { fg = syntax.func, bold = true })
hl(0, "NeoTreeFileIcon",        { fg = syntax.namespace })
hl(0, "NeoTreeFileName",        { fg = colors.fg })
hl(0, "NeoTreeSymbolicLinkTarget", { fg = syntax.keyword_flow })
hl(0, "NeoTreeModified",        { fg = colors.accents[4] })
hl(0, "NeoTreeMessage",         { fg = colors.fg_muted })
hl(0, "NeoTreeGitAdded",        { fg = colors.accents[2] })
hl(0, "NeoTreeGitModified",     { fg = colors.accents[4] })
hl(0, "NeoTreeGitDeleted",      { fg = colors.accents[1] })
hl(0, "NeoTreeGitUntracked",    { fg = syntax.func })
hl(0, "NeoTreeGitIgnored",      { fg = colors.fg_subtle })
hl(0, "NeoTreeGitUnstaged",     { fg = colors.accents[1] })
hl(0, "NeoTreeGitStaged",       { fg = colors.accents[2] })
hl(0, "NeoTreeGitConflict",     { fg = colors.accents[1], bold = true })

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
