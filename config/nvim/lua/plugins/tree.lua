return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons", -- optional, but recommended
			-- { "nvim-mini/mini.icons", version = false },
		},
		-- init = function()
		-- 	if pcall(require, "mini.icons") then
		-- 		require("mini.icons").setup()
		-- 		require("mini.icons").mock_nvim_web_devicons()
		-- 	end
		-- end,
		lazy = false,
		---@module 'neo-tree'
		---@type neotree.Config
		opts = {
			close_if_last_window = false,
			popup_border_style = "rounded",
			clipboard = {
				sync = "none", -- "none" means defferent nvim don't share clipboard, or "global"/"universal"
			},
			enable_git_status = true,
			enable_diagnostics = true,

			window = {
				auto_expand_width = false, -- expand neo-tree's width after open a file in neo-tree as the main window
				position = "right",
				width = 0.15,
				mappings = {
					["h"] = "close_node",
					["l"] = "open",
					["pl"] = "focus_preview",
				},
			},

			-- different window types
			sources = {
				"filesystem",
				"buffers",
				"git_status",
				"document_symbols",
			},

			filesystem = {
				bind_to_cwd = false,
				-- hijack_netrw_behavior = "open_current",
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
				filtered_items = {
					visible = true,
					hide_dotfiles = false,
					hide_gitignored = true,
				},
			},

			document_symbols = {
				follow_cursor = true,
				follow_tree_cursor = true,
			},
		},
	},
}
