local km = vim.keymap
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- override defaults
km.set('i', 'jk', '<Esc>')

-- neo-tree
km.set('n', '<leader>f', ':Neotree toggle<CR>' )
km.set('n', '<leader>b', ':Neotree focus buffers<CR>' )
km.set('n', '<leader>g', ':Neotree focus git_status<CR>' )
km.set('n', '<leader>o', ':Neotree document_symbols<CR>' )

km.set('n', '<leader>t', function()
  local current_win = vim.api.nvim_get_current_win()

  local buf = vim.api.nvim_win_get_buf(current_win)
  local ft = vim.bo[buf].filetype
  if ft:match("^neo%-tree") then
    vim.cmd("wincmd p")  -- return to the last window
    return
  end

  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local wbuf = vim.api.nvim_win_get_buf(win)
    local wft = vim.bo[wbuf].filetype
    if wft:match("^neo%-tree") then
      vim.api.nvim_set_current_win(win)
      return
    end
  end

  vim.cmd("Neotree reveal")
end, { desc = "Smart toggle focus: Neo-tree ↔ Editor" })

km.set('n', '<C-Right>', ':vertical resize -5<CR>' )
km.set('n', '<C-Left>', ':vertical resize +5<CR>' )
