return {
	-- https://main.cmp.saghen.dev/
	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.lib",
			-- optional: provides snippets for the snippet source
			"rafamadriz/friendly-snippets",
		},
		build = function()
			-- build the fuzzy matcher, wait up to 60 seconds
			-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
			require("blink.cmp").build():wait(60000)
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = { auto_show = false },
				ghost_text = { enabled = true },
				trigger = { prefetch_on_insert = false },
			},

			-- (Default) list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"`
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "lua" },
		},
	},

	-- https://github.com/milanglacier/minuet-ai.nvim
	{
		"milanglacier/minuet-ai.nvim",
		dependencies = {
			{ "hrsh7th/nvim-cmp", lazy = true },
			"Saghen/blink.cmp",
		},
		config = function()
			require("minuet").setup({

				cmp = {
					enable_auto_complete = false,
				},
				blink = {
					enable_auto_complete = false,
				},

				request_timeout = 3,
				throttle = 1000,
				debounce = 400,

				provider = "openai_fim_compatible",
				provider_options = {
					openai_fim_compatible = {
						api_key = "DEEPSEEK_API_KEY",
						name = "deepseek",
						optional = {
							max_tokens = 256,
							top_p = 0.9,
						},
					},
				},

				-- 行内幽灵提示
				--
				virtualtext = {
					auto_trigger_ft = {},
					keymap = {
						next = "<C-l>",
						prev = "<C-h>",
						accept = "<Tab>",
						accept_line = "<S-Tab>",
						dismiss = "<C-e>",
					},
				},
			})
		end,
	},
}
