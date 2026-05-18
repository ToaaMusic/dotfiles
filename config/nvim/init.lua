require("options")
require("theme")
require("floatterm")
require("keymaps")
require("autocmd")
require("lsp")

-- lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	spec = {
		{ import = "plugins" },
	},
	checker = { enabled = false },
})

-- vim.api.nvim_set_hl(0, "FunctionLine", { bg = "#2a3b4c" })
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "lua",
-- 	callback = function()
-- 		vim.defer_fn(function()
-- 			vim.fn.clearmatches()
--
-- 			local patterns = {
-- 				"^\\s*function\\s\\+\\w\\+", -- function name()
-- 				"^\\s*local\\s\\+function\\s\\+\\w\\+", -- local function name()
-- 				"^\\s*function\\s\\+\\w\\+[:.]\\w\\+", -- function Class:method()
-- 				"^\\s*\\w\\+\\s*=\\s*function", -- name = function()
-- 				"^\\s*local\\s\\+\\w\\+\\s*=\\s*function", -- local name = function()
-- 			}
--
-- 			for _, pattern in ipairs(patterns) do
-- 				pcall(vim.fn.matchadd, "FunctionLine", pattern, 10)
-- 			end
-- 		end, 50)
-- 	end,
-- })
