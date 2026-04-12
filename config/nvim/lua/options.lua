local op = vim.opt

-- editor
op.relativenumber = false
op.number = true
op.cursorline = true
op.cursorlineopt = "number"

op.formatoptions:remove({ "c", "r", "o" })
op.iskeyword:append("-")

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
