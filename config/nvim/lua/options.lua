local op = vim.opt
local wo = vim.wo

-- editor
op.relativenumber = false
op.number = true
op.cursorline = true
op.cursorlineopt = "number"

op.formatoptions:remove({ "c", "r", "o" })
op.iskeyword:append("-", "_")

op.termguicolors = true
op.fillchars:append({ eob = " ", fold = " " })

-- tab
op.tabstop = 2
op.shiftwidth = 2
op.expandtab = true
op.autoindent = true

-- ui
op.title = false
op.laststatus = 0
op.ruler = false

op.clipboard = "unnamedplus"

-- fold
wo.foldenable = true
-- wo.foldmethod = "expr"
-- wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
-- wo.foldlevel = 99
-- wo.foldnestmax = 5
-- op.foldmarker = "#region,#endregion"
op.foldtext = "'> ' . getline(v:foldstart)"
op.foldcolumn = '0'

op.colorcolumn = '120'
op.expandtab = false

-- wo.conceallevel = 0

-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
