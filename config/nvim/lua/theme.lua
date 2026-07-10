-- nvim/lua/theme.lua
-- https://neovim.io/doc/user/syntax/#%3Ahighlight

local set_hl = vim.api.nvim_set_hl
---@type tdf.ColorScheme
local colors = require("colors.g")
local fg = colors.fg
local bg = colors.bg
local syntax = colors.syntax
local role = colors.role

---@param map table<string, vim.api.keyset.highlight>
---@param ns_id number|nil
---@param enable boolean|nil
local function apply_hl_map(map, ns_id, enable)
	if enable ~= nil and not enable then
		return
	end
	for name, hi in pairs(map) do
		set_hl(ns_id or 0, name, hi)
	end
end

---@param map table<string, string>
---@param ns_id number|nil
---@param enable boolean|nil
local function apply_hl_map_fg_only(map, ns_id, enable)
	if enable ~= nil and not enable then
		return
	end
	for name, fg_color in pairs(map) do
		set_hl(ns_id or 0, name, { fg = fg_color })
	end
end

-- run
vim.opt.winborder = "rounded"

-- =================== built-in ====================

-- basic
-- https://neovim.io/doc/user/syntax/#highlight-groups
apply_hl_map({
	["ColorColumn"]  = { bg = bg.active }, -- max col len
	["Conceal"]      = { fg = fg.subtle },
	["CurSearch"]    = { fg = fg.common, bg = colors.accents[4] },
	["Cursor"]       = { fg = colors.accent, bg = colors.accent },
	["lCursor"]      = { fg = colors.accent, bg = colors.accent },
	["CursorIM"]     = { fg = colors.accent, bg = colors.accent },
	["CursorColumn"] = { bg = bg.hover },
	["CursorLine"]   = { bg = bg.hover },
	["Diractory"]    = { fg = fg.common },

	-- ["DiffAdd"]      = { fg = colors.accents[2] },
	-- ["DiffChange"]   = { fg = colors.accents[4] },
	-- ["DiffDelete"]   = { fg = colors.accents[1] },
	-- ["DiffText"]     = { fg = colors.accents[5] },
	-- ["DiffTextAdd"]  = { fg = colors.accents[2] },

	["EndOfBuffer"]  = { fg = "NONE", bg = "none" },
	["TermCursor"]   = { fg = colors.accent, bg = colors.accent },

	["OkMsg"]        = { fg = role.ok },
	["WarningMsg"]   = { fg = role.warning },
	["ErrorMsg"]     = { fg = role.error },
	["StderrMsg"]    = { fg = role.error },
	["StdoutMsg"]    = { fg = role.ok },

	["WinSeparator"] = { fg = bg.common },
	["Folded"]       = { bg = bg.hover, fg = fg.muted },
	["FoldColumn"]   = { fg = fg.subtle },
	["SignColumn"]   = { bg = "none" },
	["MsgArea"]      = { bg = "none" },
	["IncSearch"]    = { bg = colors.accents[4], fg = bg.common },
	-- ["Substitute"] = { fg = colors.accent, bg = fg.hover },
	["LineNr"]       = { fg = fg.subtle },
	-- ["LineNrAbove"] = { fg = fg.subtle, bold = false },
	-- ["LineNrBelow"] = { fg = fg.subtle, bold = false },
	["CursorLineNr"] = { fg = fg.hover, bold = true },
	-- ["CursorLineFold"] = { fg = fg.subtle, bg = "none" },
	-- ["CursorLineSign"] = { fg = fg.subtle, bg = "none" },
	["MatchParen"]   = { bg = bg.hover, bold = true },
	-- ["ModeMsg"] = { fg = fg.muted },
	-- ["MsgArea"] = { bg = bg.common},
	-- ["MsgSeparator"] = { fg = fg.muted },
	-- ["MoreMsg"] = { fg = colors.accents[2] },
	-- ["NonText"] = { fg = fg.subtle },

	["Normal"]       = { bg = "none", fg = fg.common },
	["NormalFloat"]  = { bg = "none", fg = fg.common },
	["FloatBorder"]  = { bg = "none", fg = bg.border, bold = true },
	-- ["FloatShadow"] = { bg = fg.common},
	-- ["FloatShadowThrough"] = { bg = fg.common},
	-- ["FloatTitle"] = { fg = fg.common},
	-- ["FloatFooter"] = { fg = fg.common},
	["NormalNC"]     = { bg = "none", fg = fg.muted },

	["Pmenu"]        = { bg = bg.elevated, fg = fg.common },
	["PmenuSel"]     = { bg = colors.accent, fg = colors.accents[4] },
	["PmenuKind"]    = { bg = "none", fg = syntax.type },
	["PmenuExtra"]   = { bg = "none", fg = fg.subtle },
	["PmenuThumb"]   = { bg = colors.accent[4] },

	-- ["ComplMatchIns"] = nil
	-- ["PreInsert"] = nil
	-- ["ComplHint"] = nil
	-- ["ComplHintMore"] = nil
	-- ["Question"] = { fg = colors.accents[5] },
	-- ["QuickFixLine"] = { bg = bg.active },
	["Search"]       = { bg = colors.accent[3], fg = bg.common },
	-- ["SpecialKey"] = { fg = fg.subtle },

	-- ["SpellBad"] = { sp = colors.accents[1], undercurl = true },
	-- ["SpellCap"] = { sp = colors.accents[3], undercurl = true },
	-- ["SpellLocal"] = { sp = colors.accents[4], undercurl = true },
	-- ["SpellRare"] = { sp = colors.accents[0xd], undercurl = true },

	["StatusLine"]   = { bg = bg.active, fg = fg.common },
	["StatusLineNC"] = { bg = bg.elevated, fg = fg.muted },

	["TabLine"]      = { bg = bg.elevated, fg = fg.muted },
	["TabLineFill"]  = { bg = bg.common },
	["TabLineSel"]   = { bg = colors.accent, fg = colors.accents[1], bold = true },

	["Title"]        = { fg = colors.accent, bold = true },
	["Visual"]       = { bg = bg.active },

	-- ["WildMenu"] = { bg = colors.accent, fg = colors.accent_fg },
})

-- std syntax
-- https://neovim.io/doc/user/syntax/#group-name
apply_hl_map({
	["Comment"]        = { fg = syntax.comment, italic = true },

	["Constant"]       = { fg = syntax.constant }, -- const
	["String"]         = { fg = syntax.string },
	["Character"]      = { fg = syntax.string },  -- char
	["Number"]         = { fg = syntax.number },
	["Boolean"]        = { fg = syntax.builtin },
	["Float"]          = { fg = syntax.number },

	["Identifier"]     = { fg = syntax.variable },
	["Function"]       = { fg = syntax.func },

	["Statement"]      = { fg = syntax.keyword_flow },
	["Conditional"]    = { fg = syntax.keyword_flow },
	["Repeat"]         = { fg = syntax.keyword_flow },
	["Label"]          = { fg = syntax.namespace },
	["Operator"]       = { fg = syntax.operator },
	["Keyword"]        = { fg = syntax.keyword },
	["Exception"]      = { fg = syntax.keyword_return },

	["PreProc"]        = { fg = syntax.macro },
	["Include"]        = { fg = syntax.macro },
	["Define"]         = { fg = syntax.macro },
	["Macro"]          = { fg = syntax.macro },
	["PreCondit"]      = { fg = syntax.macro },

	["Type"]           = { fg = syntax.type },
	["StorageClass"]   = { fg = syntax.type },
	["Structure"]      = { fg = syntax.type },
	["Typedef"]        = { fg = syntax.type },

	["Special"]        = { fg = syntax.builtin },
	["SpecialChar"]    = { fg = syntax.constant },
	["Tag"]            = { fg = syntax.type },
	["Delimiter"]      = { fg = syntax.punctuation },
	["SpecialComment"] = { fg = fg.subtle, italic = true },
	["Debug"]          = { fg = colors.accents[1] },

	["Underlined"]     = { underline = true },
	["Dimmed"]         = { fg = fg.subtle },

	["Ignore"]         = { fg = fg.subtle },

	["Error"]          = { fg = role.error, bold = true },

	["Todo"]           = { fg = role.info, bold = true },

	["Added"]          = { fg = role.add },
	["Changed"]        = { fg = role.change },
	["Removed"]        = { fg = role.delete },
})

-- diagnostics
-- https://neovim.io/doc/user/diagnostic/#diagnostic-highlights
apply_hl_map({
	["DiagnosticError"]             = { fg = colors.accents[1] },
	["DiagnosticWarn"]              = { fg = colors.accents[3] },
	["DiagnosticInfo"]              = { fg = colors.accents[5] },
	["DiagnosticHint"]              = { fg = colors.accents[6] },
	["DiagnosticOk"]                = { fg = colors.accents[2] },

	["DiagnosticVirtualTextError"]  = { fg = colors.accents[1] },
	["DiagnosticVirtualTextWarn"]   = { fg = colors.accents[3] },
	["DiagnosticVirtualTextInfo"]   = { fg = colors.accents[5] },
	["DiagnosticVirtualTextHint"]   = { fg = colors.accents[6] },
	["DiagnosticVirtualTextOk"]     = { fg = colors.accents[2] },

	["DiagnosticVirtualLinesError"] = { fg = colors.accents[1] },
	["DiagnosticVirtualLinesWarn"]  = { fg = colors.accents[3] },
	["DiagnosticVirtualLinesInfo"]  = { fg = colors.accents[5] },
	["DiagnosticVirtualLinesHint"]  = { fg = colors.accents[6] },
	["DiagnosticVirtualLinesOk"]    = { fg = colors.accents[2] },

	["DiagnosticUnderlineError"]    = { undercurl = true, sp = colors.accents[1] },
	["DiagnosticUnderlineWarn"]     = { undercurl = true, sp = colors.accents[3] },
	["DiagnosticUnderlineInfo"]     = { undercurl = true, sp = colors.accents[5] },
	["DiagnosticUnderlineHint"]     = { undercurl = true, sp = colors.accents[6] },
	["DiagnosticUnderlineOk"]       = { undercurl = true, sp = colors.accents[2] },

	["DiagnosticFloatingError"]     = { fg = colors.accents[1] },
	["DiagnosticFloatingWarn"]      = { fg = colors.accents[3] },
	["DiagnosticFloatingInfo"]      = { fg = colors.accents[5] },
	["DiagnosticFloatingHint"]      = { fg = colors.accents[6] },
	["DiagnosticFloatingOk"]        = { fg = colors.accents[2] },

	["DiagnosticSignError"]         = { fg = colors.accents[1] },
	["DiagnosticSignWarn"]          = { fg = colors.accents[3] },
	["DiagnosticSignInfo"]          = { fg = colors.accents[5] },
	["DiagnosticSignHint"]          = { fg = colors.accents[6] },
	["DiagnosticSignOk"]            = { fg = colors.accents[2] },

	["DiagnosticUnnecessary"]       = { fg = fg.subtle },
	["DiagnosticDeprecated"]        = { fg = fg.subtle, strikethrough = true },
})

-- treesitter
-- https://neovim.io/doc/user/treesitter/#treesitter-highlight-groups
apply_hl_map({
	["@variable"]                   = { fg = syntax.variable },
	["@variable.builtin"]           = { fg = syntax.builtin },
	["@variable.parameter"]         = { fg = syntax.parameter },
	["@variable.parameter.builtin"] = { fg = syntax.builtin },
	["@variable.member"]            = { fg = syntax.property },

	["@constant"]                   = { link = "Constant" },
	["@constant.builtin"]           = { fg = syntax.builtin },
	["@constant.macro"]             = { fg = syntax.macro },

	["@module"]                     = { fg = syntax.namespace },
	["@module.builtin"]             = { fg = syntax.namespace },
	["@label"]                      = { fg = syntax.namespace },

	["@string"]                     = { link = "String" },
	["@string.documentation"]       = { link = "String" },
	["@string.regexp"]              = { fg = syntax.constant },
	["@string.escape"]              = { fg = syntax.constant },
	["@string.special"]             = { fg = syntax.builtin },
	["@string.special.symbol"]      = { fg = syntax.builtin },
	["@string.special.path"]        = { fg = syntax.namespace },
	["@string.special.url"]         = { fg = syntax.namespace, underline = true },

	-- ["@character"] = { link = "Charactor" },
	-- ["@character.special"] = { link = "Charactor" },

	["@boolean"]                    = { link = "Boolean" },
	["@number"]                     = { link = "Number" },
	["@number.float"]               = { link = "Float" },

	["@type"]                       = { link = "Type" },
	["@type.builtin"]               = { fg = syntax.builtin },
	["@type.definition"]            = { fg = syntax.namespace },

	-- ["@attribute"] = { fg = syntax.macro },
	-- ["@attribute.builtin"] = { fg = syntax.macro },
	["@property"]                   = { fg = syntax.property },

	["@function"]                   = { link = "Function" },
	["@function.builtin"]           = { fg = syntax.builtin },
	["@function.call"]              = { fg = syntax.func_call },
	["@function.macro"]             = { fg = syntax.macro },

	["@function.method"]            = { link = "Function" },
	["@function.method.call"]       = { fg = syntax.func_call },

	["@constructor"]                = { fg = syntax.type },
	["@operator"]                   = { link = "Operator" },

	["@keyword"]                    = { link = "Keyword" },
	-- ["@keyword.coroutine"] = { fg = syntax.keyword },
	["@keyword.function"]           = { fg = syntax.keyword_flow },
	["@keyword.operator"]           = { fg = syntax.operator },
	["@keyword.import"]             = { fg = syntax.macro },
	-- ["@keyword.type"] = { fg = syntax.type },
	-- ["@keyword.modifier"] = { fg = syntax.keyword },
	["@keyword.repeat"]             = { fg = syntax.keyword_flow },
	["@keyword.return"]             = { fg = syntax.keyword_return, italic = true },
	-- ["@keyword.debug"] = { fg = colors.accents[1] },
	["@keyword.exception"]          = { fg = syntax.keyword_return },

	["@keyword.conditional"]        = { fg = syntax.keyword_flow },
	-- ["@keyword.conditional.ternary"] = { fg = syntax.operator },

	-- ["@keyword.directive"] = { fg = syntax.macro },
	-- ["@keyword.directive.define"] = { fg = syntax.macro },

	["@punctuation.delimiter"]      = { fg = syntax.punctuation },
	["@punctuation.bracket"]        = { fg = syntax.punctuation },
	["@punctuation.special"]        = { fg = syntax.builtin },

	["@comment"]                    = { link = "Comment" },
	["@comment.documentation"]      = { link = "Comment" },

	["@comment.error"]              = { link = "ErrorMsg" },
	["@comment.warning"]            = { link = "WarningMsg" },
	["@comment.todo"]               = { link = "Todo" },
	["@comment.note"]               = { fg = role.info, bold = true },

	["@markup.strong"]              = { fg = fg.common, bold = true },
	["@markup.italic"]              = { fg = fg.common, italic = true },
	["@markup.strikethrough"]       = { fg = fg.common, strikethrough = true },
	["@markup.underline"]           = { fg = fg.common, underline = true },

	["@markup.heading"]             = { fg = fg.common },
	["@markup.heading.1"]           = { fg = fg.common },
	["@markup.heading.2"]           = { fg = fg.common },
	["@markup.heading.3"]           = { fg = fg.common },
	["@markup.heading.4"]           = { fg = fg.common },
	["@markup.heading.5"]           = { fg = fg.common },
	["@markup.heading.6"]           = { fg = fg.common },

	["@markup.quote"]               = { fg = fg.muted, italic = true },
	["@markup.math"]                = { fg = syntax.constant },

	["@markup.link"]                = { fg = syntax.namespace, underline = true },
	["@markup.link.label"]          = { fg = syntax.namespace },
	["@markup.link.url"]            = { fg = syntax.namespace, underline = true },

	["@markup.raw"]                 = { fg = syntax.builtin, bg = "none" },
	["@markup.raw.block"]           = { fg = syntax.builtin },

	["@markup.list"]                = { fg = syntax.keyword },
	["@markup.list.checked"]        = { fg = syntax.keyword },
	["@markup.list.unchecked"]      = { fg = syntax.keyword },

	["@diff.plus"]                  = { fg = colors.accents[2] },
	["@diff.minus"]                 = { fg = colors.accents[1] },
	["@diff.delta"]                 = { fg = colors.accents[4] },

	["@tag"]                        = { fg = syntax.type },
	["@tag.builtin"]                = { fg = syntax.type },
	["@tag.attribute"]              = { fg = syntax.property },
	["@tag.delimiter"]              = { fg = syntax.punctuation },

	-- not in vimdocs
	["@namespace"]                  = { fg = syntax.namespace },
	["@field"]                      = { fg = syntax.property },
	["@parameter"]                  = { fg = syntax.parameter },
})

-- lsp semantic
-- https://neovim.io/doc/user/lsp/#lsp-semantic-highlight
apply_hl_map_fg_only({
	["@lsp.type.class"]         = syntax.type,
	["@lsp.type.enum"]          = syntax.type,
	["@lsp.type.enumMember"]    = syntax.constant,
	["@lsp.type.event"]         = syntax.constant,
	["@lsp.type.function"]      = syntax.func,
	["@lsp.type.interface"]     = syntax.type,
	["@lsp.type.keyword"]       = syntax.keyword,
	["@lsp.type.macro"]         = syntax.macro,
	["@lsp.type.method"]        = syntax.func,
	["@lsp.type.namespace"]     = syntax.namespace,
	["@lsp.type.number"]        = syntax.number,
	["@lsp.type.operator"]      = syntax.operator,
	["@lsp.type.parameter"]     = syntax.parameter,
	["@lsp.type.property"]      = syntax.property,
	["@lsp.type.boolean"]       = syntax.builtin,
	["@lsp.type.constant"]      = syntax.constant,
	["@lsp.type.regexp"]        = syntax.constant,
	["@lsp.type.string"]        = syntax.string,
	["@lsp.type.struct"]        = syntax.type,
	["@lsp.type.type"]          = syntax.type,
	["@lsp.type.typeParameter"] = syntax.type,
	["@lsp.type.variable"]      = syntax.variable,
	["@lsp.type.decorator"]     = syntax.macro,
	["@lsp.type.modifier"]      = syntax.keyword,
})

apply_hl_map({
	["@lsp.type.comment"]   = { link = "Comment" },
	["@lsp.mod.deprecated"] = { fg = fg.subtle, strikethrough = true },
})

-- lsp
-- https://neovim.io/doc/user/lsp/#lsp-highlight
apply_hl_map({
	-- ["LspReferenceText"] = { bg = bg.hover },
	-- ["LspReferenceRead"] = { bg = bg.hover },
	-- ["LspReferenceWrite"] = { bg = bg.hover },
	-- ["LspReferenceTarget"] = { fg = fg.common, bold = true },
	-- ["LspInlayHint"] = { fg = fg.subtle, bg = bg.active },
	-- ["LspCodeLens"] = { fg = fg.subtle },
	-- ["LspCodeLensSeparator"] = { fg = fg.subtle },
	["LspSignatureActiveParameter"] = { bg = bg.hover },
})

-- ==================== plugins ====================

-- blink
-- https://github.com/saghen/blink.cmp
apply_hl_map({
	["BlinkCmpKind"]                = { bg = "none", fg = syntax.type },
	["BlinkCmpKindText"]            = { bg = "none", fg = syntax.type },
	["BlinkCmpKindMethod"]          = { bg = "none", fg = syntax.func },
	["BlinkCmpKindFunction"]        = { bg = "none", fg = syntax.func },
	["BlinkCmpKindVariable"]        = { bg = "none", fg = syntax.variable },
	["BlinkCmpKindClass"]           = { bg = "none", fg = syntax.type },
	["BlinkCmpKindInterface"]       = { bg = "none", fg = syntax.type },
	["BlinkCmpKindModule"]          = { bg = "none", fg = syntax.namespace },
	["BlinkCmpKindProperty"]        = { bg = "none", fg = syntax.property },
	["BlinkCmpKindField"]           = { bg = "none", fg = syntax.property },
	["BlinkCmpKindKeyword"]         = { bg = "none", fg = syntax.keyword },
	["BlinkCmpKindSnippet"]         = { bg = "none", fg = syntax.constant },
	["BlinkCmpKindConstant"]        = { bg = "none", fg = syntax.constant },
	["BlinkCmpMenu"]                = { bg = "none", fg = fg.common },
	["BlinkCmpMenuBorder"]          = { fg = bg.border, bg = "none" },
	["BlinkCmpDoc"]                 = { bg = "none", fg = fg.common },
	["BlinkCmpDocBorder"]           = { fg = bg.border, bg = "none" },
	["BlinkCmpSignatureHelp"]       = { bg = "none", fg = fg.common },
	["BlinkCmpSignatureHelpBorder"] = { fg = bg.border, bg = "none" },
})

-- neo-tree
-- https://github.com/nvim-neo-tree/neo-tree.nvim
apply_hl_map({
	["NeoTreeNormal"]               = { fg = fg.common, bg = "none" },
	["NeoTreeNormalNC"]             = { fg = fg.muted, bg = "none" },
	["NeoTreeFloatBorder"]          = { fg = bg.border, bg = "none" },
	["NeoTreeWinSeparator"]         = { fg = bg.border, bg = "none" },
	["NeoTreeTabActive"]            = { fg = fg.common, bg = "none" },
	["NeoTreeTabInactive"]          = { fg = fg.muted, bg = "none" },
	["NeoTreeTabSeparatorActive"]   = { fg = "none", bg = "none" },
	["NeoTreeTabSeparatorInactive"] = { fg = "none", bg = "none" },
	["NeoTreeRootName"]             = { fg = syntax.namespace, bold = true },
	["NeoTreeIndentMarker"]         = { fg = syntax.comment, bg = "none" },
	["NeoTreeExpander"]             = { fg = syntax.punctuation, bg = "none" },
	["NeoTreeDirectoryName"]        = { fg = syntax.namespace },
	["NeoTreeDirectoryIcon"]        = { fg = syntax.namespace },
	["NeoTreeOpenedFolderName"]     = { fg = syntax.func, bold = true },
	["NeoTreeFileIcon"]             = { fg = syntax.namespace },
	["NeoTreeFileName"]             = { fg = fg.common },
	["NeoTreeSymbolicLinkTarget"]   = { fg = syntax.keyword_flow },
	["NeoTreeModified"]             = { fg = role.change },
	["NeoTreeMessage"]              = { fg = colors.accent },

	["NeoTreeGitAdded"]             = { fg = role.add },
	["NeoTreeGitModified"]          = { fg = role.change },
	["NeoTreeGitDeleted"]           = { fg = role.delete },
	["NeoTreeGitUntracked"]         = { fg = role.delete },
	["NeoTreeGitIgnored"]           = { fg = syntax.comment },
	["NeoTreeGitUnstaged"]          = { fg = colors.accents[1] },
	["NeoTreeGitStaged"]            = { fg = colors.accents[2] },
	["NeoTreeGitConflict"]          = { fg = role.error, bold = true },
})

-- gitsigns
-- https://github.com/lewis6991/gitsigns.nvim
apply_hl_map({
	["GitSignsAdd"]       = { fg = role.add },
	["GitSignsChange"]    = { fg = role.change },
	["GitSignsDelete"]    = { fg = role.delete },
	-- ["GitSignsChangedelete"] = { link = "GitSignsChange" },
	-- ["GitSignsTopdelete"]    = { link = "GitSignsDelete" },
	-- ["GitSignsUntracked"]    = { link = "GitSignsAdd" },
	-- ["GitSignsStagedAdd"] = { link = "GitSignsAdd" },
})

-- render-markdown
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
-- (!! RenderMarkdownHx 只是 icon, 而 RenderMarkdownHxBg 才是文本行，包括 fg 和 bg )
apply_hl_map({
	["RenderMarkdownH1Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownH2Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownH3Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownH4Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownH5Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownH6Bg"]       = { fg = fg.common, bold = true },
	["RenderMarkdownCode"]       = { bg = bg.common },
	["RenderMarkdownCodeInline"] = { fg = fg.common },
	["RenderMarkdownCodeInfo"]   = { fg = fg.common },
	["RenderMarkdownCodeBorder"] = { fg = fg.common },
})
