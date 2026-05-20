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

local theme_reload = augroup("ThemeReload", { clear = true })
autocmd("BufWritePost", {
  group = theme_reload,
  pattern = vim.fn.stdpath("config") .. "/lua/colors/g.lua",
  callback = function()
    package.loaded["colors.g"] = nil
    local theme_file = vim.fn.stdpath("config") .. "/lua/theme.lua"
    local ok, err = pcall(dofile, theme_file)
    if ok then
      vim.notify("✅ Theme reloaded!", vim.log.levels.INFO)
      vim.cmd("redraw!")
    else
      vim.notify("❌ Theme reload failed: " .. tostring(err), vim.log.levels.ERROR)
    end
  end,
})
