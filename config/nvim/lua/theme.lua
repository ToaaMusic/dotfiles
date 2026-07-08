-- nvim/lua/theme.lua
-- https://neovim.io/doc/user/syntax/#%3Ahighlight

local set_hl = vim.api.nvim_set_hl

---@type tdf.ColorScheme
local colors = require("colors.g")
local syntax = colors.syntax

-- preset maps
local bg_fg = { bg = colors.bg.common, fg = colors.fg.common }

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

local function set_bg_transparent()
	for _, group in ipairs({
		"Normal",
		"NormalNC",
		"SignColumn",
		"EndOfBuffer",
		"MsgArea",
		-- "FloatBorder",
		"NormalFloat",
	}) do
		set_hl(0, group, { bg = "none" })
	end
end

-- run
vim.opt.winborder = "rounded"

-- =================== built-in ====================

-- basic
-- https://neovim.io/doc/user/syntax/#highlight-groups
apply_hl_map({
	["ColorColumn"]   = { bg = colors.bg.active }, -- max col len
	["Conceal"]       = { fg = colors.fg.subtle },
	["CurSearch"]     = { fg = colors.fg.common, bg = colors.accents[4] },
	["Cursor"]        = { fg = colors.accent, bg = colors.accent },
	["lCursor"]       = { fg = colors.accent, bg = colors.accent },
	["CursorIM"]      = { fg = colors.accent, bg = colors.accent },
	["CursorColumn"]  = { bg = colors.bg.hover },
	["CursorLine"]    = { bg = colors.bg.hover },
	["Diractory"]     = { fg = colors.fg.common },

	["DiffAdd"]       = { fg = colors.accents[2] },
	["DiffChange"]    = { fg = colors.accents[4] },
	["DiffDelete"]    = { fg = colors.accents[1] },
	["DiffText"]      = { fg = colors.accents[5] },
	["DiffTextAddTo"] = { fg = colors.accents[2] },

	["EndOfBuffer"]   = { fg = "NONE" },
	["TermCursor"]    = { fg = colors.accent, bg = colors.accent },

	["OkMsg"]         = { fg = colors.accents[2] },
	["WarningMsg"]    = { fg = colors.accents[3] },
	["ErrorMsg"]      = { fg = colors.accents[1] },
	["StderrMsg"]     = { fg = colors.accents[1] },
	["StdoutMsg"]     = { fg = colors.accents[2] },

	["WinSeparator"]  = { fg = colors.bg.common },
	["Folded"]        = { bg = colors.bg.hover, fg = colors.fg.muted },
	["FoldColumn"]    = { fg = colors.fg.subtle },
	-- ["SignColumn"] = { fg = "none", bg = "none" },
	["IncSearch"]     = { bg = colors.accents[4], fg = colors.bg.common },
	-- ["Substitute"] = { fg = colors.accent, bg = colors.fg.hover },
	["LineNr"]        = { fg = colors.fg.subtle },
	-- ["LineNrAbove"] = { fg = colors.fg.subtle, bold = false },
	-- ["LineNrBelow"] = { fg = colors.fg.subtle, bold = false },
	["CursorLineNr"]  = { fg = colors.fg.hover, bold = true },
	-- ["CursorLineFold"] = { fg = colors.fg.subtle, bg = "none" },
	-- ["CursorLineSign"] = { fg = colors.fg.subtle, bg = "none" },
	["MatchParen"]    = { bg = colors.bg.hover, bold = true },
	-- ["ModeMsg"] = { fg = colors.fg.muted },
	-- ["MsgArea"] = { bg = colors.bg.common},
	-- ["MsgSeparator"] = { fg = colors.fg.muted },
	-- ["MoreMsg"] = { fg = colors.accents[2] },
	-- ["NonText"] = { fg = colors.fg.subtle },

	["Normal"]        = bg_fg,
	["NormalFloat"]   = { bg = colors.bg.elevated, fg = colors.fg.common },
	["FloatBorder"]   = { bg = "none", fg = colors.bg.border, bold = true },
	-- ["FloatShadow"] = { bg = colors.fg.common},
	-- ["FloatShadowThrough"] = { bg = colors.fg.common},
	-- ["FloatTitle"] = { fg = colors.fg.common},
	-- ["FloatFooter"] = { fg = colors.fg.common},
	["NormalNC"]      = { bg = colors.bg.common, fg = colors.fg.muted },

	["Pmenu"]         = { bg = colors.bg.elevated, fg = colors.fg.common },
	["PmenuSel"]      = { bg = colors.accent, fg = colors.accents[4] },
	["PmenuKind"]     = { bg = "none", fg = syntax.type },
	["PmenuExtra"]    = { bg = "none", fg = colors.fg.subtle },
	["PmenuThumb"]    = { bg = colors.accent[4] },

	-- ["ComplMatchIns"] = nil
	-- ["PreInsert"] = nil
	-- ["ComplHint"] = nil
	-- ["ComplHintMore"] = nil
	-- ["Question"] = { fg = colors.accents[5] },
	-- ["QuickFixLine"] = { bg = colors.bg.active },
	["Search"]        = { bg = colors.accent[3], fg = colors.bg.common },
	-- ["SpecialKey"] = { fg = colors.fg.subtle },

	-- ["SpellBad"] = { sp = colors.accents[1], undercurl = true },
	-- ["SpellCap"] = { sp = colors.accents[3], undercurl = true },
	-- ["SpellLocal"] = { sp = colors.accents[4], undercurl = true },
	-- ["SpellRare"] = { sp = colors.accents[0xd], undercurl = true },

	["StatusLine"]    = { bg = colors.bg.active, fg = colors.fg.common },
	["StatusLineNC"]  = { bg = colors.bg.elevated, fg = colors.fg.muted },

	["TabLine"]       = { bg = colors.bg.elevated, fg = colors.fg.muted },
	["TabLineFill"]   = { bg = colors.bg.common },
	["TabLineSel"]    = { bg = colors.accent, fg = colors.accents[1], bold = true },

	["Title"]         = { fg = colors.accents[4], bold = true },
	["Visual"]        = { bg = colors.bg.active },

	-- ["WildMenu"] = { bg = colors.accent, fg = colors.accent_fg },
})

-- std syntax
-- https://neovim.io/doc/user/syntax/#group-name
apply_hl_map({
	["Comment"]        = { fg = syntax.comment, italic = true },

	["Constant"]       = { fg = syntax.constant },
	["String"]         = { fg = syntax.string },
	["Character"]      = { fg = syntax.string },
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
	["SpecialComment"] = { fg = colors.fg.subtle, italic = true },
	["Debug"]          = { fg = colors.accents[1] },

	["Underlined"]     = { underline = true },
	["Dimmed"]         = { fg = colors.fg.subtle },

	["Ignore"]         = { fg = colors.fg.subtle },

	["Error"]          = { fg = colors.accents[1], bold = true },

	["Todo"]           = { fg = colors.accents[4], bold = true },

	["Added"]          = { fg = colors.accents[2] },
	["Changed"]        = { fg = colors.accents[4] },
	["Removed"]        = { fg = colors.accents[1] },
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

	["DiagnosticUnnecessary"]       = { fg = colors.fg.subtle },
	["DiagnosticDeprecated"]        = { fg = colors.fg.subtle, strikethrough = true },
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

	["@function.method"]            = { fg = syntax.func },
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
	["@comment.note"]               = { fg = colors.accents[5], bold = true },

	["@markup.strong"]              = { fg = colors.fg.common, bold = true },
	["@markup.italic"]              = { fg = colors.fg.common, italic = true },
	["@markup.strikethrough"]       = { fg = colors.fg.common, strikethrough = true },
	["@markup.underline"]           = { fg = colors.fg.common, underline = true },

	-- TODO: need ".markdown"?
	["@markup.heading"]             = { fg = colors.fg.common },
	["@markup.heading.1"]           = { fg = colors.fg.common },
	["@markup.heading.2"]           = { fg = colors.fg.common },
	["@markup.heading.3"]           = { fg = colors.fg.common },
	["@markup.heading.4"]           = { fg = colors.fg.common },
	["@markup.heading.5"]           = { fg = colors.fg.common },
	["@markup.heading.6"]           = { fg = colors.fg.common },

	["@markup.quote"]               = { fg = colors.fg.muted, italic = true },
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
	["@lsp.mod.deprecated"] = { fg = colors.fg.subtle, strikethrough = true },
})

-- lsp
-- https://neovim.io/doc/user/lsp/#lsp-highlight
apply_hl_map({
	-- ["LspReferenceText"] = { bg = colors.bg.hover },
	-- ["LspReferenceRead"] = { bg = colors.bg.hover },
	-- ["LspReferenceWrite"] = { bg = colors.bg.hover },
	-- ["LspReferenceTarget"] = { fg = colors.fg.common, bold = true },
	-- ["LspInlayHint"] = { fg = colors.fg.subtle, bg = colors.bg.active },
	-- ["LspCodeLens"] = { fg = colors.fg.subtle },
	-- ["LspCodeLensSeparator"] = { fg = colors.fg.subtle },
	["LspSignatureActiveParameter"] = { bg = colors.bg.hover },
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
	["BlinkCmpMenu"]                = { bg = "none", fg = colors.fg.common },
	["BlinkCmpMenuBorder"]          = { fg = colors.bg.border, bg = "none" },
	["BlinkCmpDoc"]                 = { bg = "none", fg = colors.fg.common },
	["BlinkCmpDocBorder"]           = { fg = colors.bg.border, bg = "none" },
	["BlinkCmpSignatureHelp"]       = { bg = "none", fg = colors.fg.common },
	["BlinkCmpSignatureHelpBorder"] = { fg = colors.bg.border, bg = "none" },
})

-- neo-tree
-- https://github.com/nvim-neo-tree/neo-tree.nvim
apply_hl_map({
	["NeoTreeNormal"]               = { bg = "none", fg = colors.fg.common },
	["NeoTreeNormalNC"]             = { bg = "none", fg = colors.fg.muted },
	["NeoTreeFloatBorder"]          = { fg = colors.bg.border, bg = "none" },
	["NeoTreeWinSeparator"]         = { fg = colors.bg.border, bg = "none" },
	["NeoTreeTabActive"]            = { fg = colors.fg.common, bg = "none" },
	["NeoTreeTabInactive"]          = { fg = colors.fg.muted, bg = "none" },
	["NeoTreeTabSeparatorActive"]   = { fg = "none", bg = "none" },
	["NeoTreeTabSeparatorInactive"] = { fg = "none", bg = "none" },
	["NeoTreeRootName"]             = { fg = colors.fg.common, bold = true },
	["NeoTreeIndentMarker"]         = { fg = colors.bg.border, bg = "none" },
	["NeoTreeExpander"]             = { fg = syntax.punctuation, bg = "none" },
	["NeoTreeDirectoryName"]        = { fg = syntax.namespace },
	["NeoTreeDirectoryIcon"]        = { fg = syntax.namespace },
	["NeoTreeOpenedFolderName"]     = { fg = syntax.func, bold = true },
	["NeoTreeFileIcon"]             = { fg = syntax.namespace },
	["NeoTreeFileName"]             = { fg = colors.fg.common },
	["NeoTreeSymbolicLinkTarget"]   = { fg = syntax.keyword_flow },
	["NeoTreeModified"]             = { fg = colors.accents[4] },
	["NeoTreeMessage"]              = { fg = colors.fg.muted },
	["NeoTreeGitAdded"]             = { fg = colors.accents[2] },
	["NeoTreeGitModified"]          = { fg = colors.accents[4] },
	["NeoTreeGitDeleted"]           = { fg = colors.accents[1] },
	["NeoTreeGitUntracked"]         = { fg = syntax.func },
	["NeoTreeGitIgnored"]           = { fg = colors.fg.subtle },
	["NeoTreeGitUnstaged"]          = { fg = colors.accents[1] },
	["NeoTreeGitStaged"]            = { fg = colors.accents[2] },
	["NeoTreeGitConflict"]          = { fg = colors.accents[1], bold = true },
})

-- gitsigns
-- https://github.com/lewis6991/gitsigns.nvim
apply_hl_map({
	["GitSignsAdd"]    = { fg = colors.accents[2] },
	["GitSignsChange"] = { fg = colors.accents[4] },
	["GitSignsDelete"] = { fg = colors.accents[1] },
	["GitSignsStaged"] = { fg = colors.accents[2] },
})

-- render-markdown
-- https://github.com/MeanderingProgrammer/render-markdown.nvim
-- (!! RenderMarkdownHx 只是 icon, 而 RenderMarkdownHxBg 才是文本行，包括 fg 和 bg )
apply_hl_map({
	["RenderMarkdownH1Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownH2Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownH3Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownH4Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownH5Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownH6Bg"]       = { fg = colors.fg.common, bold = true },
	["RenderMarkdownCode"]       = { bg = colors.bg.common },
	["RenderMarkdownCodeInline"] = { fg = colors.fg.common },
	["RenderMarkdownCodeInfo"]   = { fg = colors.fg.common },
	["RenderMarkdownCodeBorder"] = { fg = colors.fg.common },
})

set_bg_transparent()
