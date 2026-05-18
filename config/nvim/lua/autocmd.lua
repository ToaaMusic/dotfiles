-- lua/autocmd.lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local general = augroup("GeneralSettings", { clear = true })

-- auto save and load view state
autocmd({ "BufWinLeave", "BufLeave", "BufWritePost", "BufHidden", "QuitPre" }, {
  group = general,
  pattern = "?*",
  nested = true,
  callback = function()
    pcall(vim.cmd, "mkview!")
  end,
})

autocmd("BufWinEnter", {
  group = general,
  pattern = "?*",
  callback = function()
    pcall(vim.cmd, "loadview")
  end,
})
