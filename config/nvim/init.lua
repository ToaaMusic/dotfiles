require("options")
require("theme")
require("theme_watcher")
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
		-- {
		-- 	"folke/lazydev.nvim",
		-- 	ft = "lua", -- only load on lua files
		-- 	opts = {
		-- 		library = {
		-- 			-- Library paths can be absolute
		-- 			"~/projects/my-awesome-lib",
		-- 			-- Or relative, which means they will be resolved from the plugin dir.
		-- 			"lazy.nvim",
		-- 			-- It can also be a table with trigger words / mods
		-- 			-- Only load luvit types when the `vim.uv` word is found
		-- 			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		-- 			-- always load the LazyVim library
		-- 			"LazyVim",
		-- 			-- Only load the lazyvim library when the `LazyVim` global is found
		-- 			{ path = "LazyVim", words = { "LazyVim" } },
		-- 			-- Load the wezterm types when the `wezterm` module is required
		-- 			-- Needs `DrKJeff16/wezterm-types` to be installed
		-- 			{ path = "wezterm-types", mods = { "wezterm" } },
		-- 			-- Load the xmake types when opening file named `xmake.lua`
		-- 			-- Needs `LelouchHe/xmake-luals-addon` to be installed
		-- 			{ path = "xmake-luals-addon/library", files = { "xmake.lua" } },
		-- 		},
		-- 		-- always enable unless `vim.g.lazydev_enabled = false`
		-- 		-- This is the default
		-- 		enabled = function(root_dir)
		-- 			return vim.g.lazydev_enabled == nil and true or vim.g.lazydev_enabled
		-- 		end,
		-- 		-- disable when a .luarc.json file is found
		-- 		-- enabled = function(root_dir)
		-- 		-- 	return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
		-- 		-- end,
		-- 	},
		-- },
	},
	checker = { enabled = false },
})
