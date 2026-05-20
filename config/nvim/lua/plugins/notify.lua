return {
	-- https://github.com/j-hui/fidget.nvim
	{
		"j-hui/fidget.nvim",
		opts = {
			notification = {
				override_vim_notify = true,
			},
		},
	},
	-- {
	-- 	"rcarriga/nvim-notify",
	-- 	config = function()
	-- 		local notify = require("notify")
	-- 		notify.setup({
	-- 			position = "bottom_left",
	-- 		})
	-- 		vim.notify = notify
	-- 	end,
	-- },
	-- {
	-- 	"mrded/nvim-lsp-notify",
	-- 	dependencies = { "rcarriga/nvim-notify" },
	-- 	config = function()
	-- 		require("lsp-notify").setup({
	--
	-- 		})
	-- 	end,
	-- },
}
