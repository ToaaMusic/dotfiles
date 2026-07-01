return {
	-- https://main.cmp.saghen.dev/
	{
		"saghen/blink.cmp",
		dependencies = {
			"saghen/blink.lib",
			-- optional: provides snippets for the snippet source
			"rafamadriz/friendly-snippets",
			{ "nvim-mini/mini.icons", version = false },
		},
		build = function()
			-- build the fuzzy matcher, optionally add a timeout to `pwait(timeout_ms)`
			-- you can use `gb` in `:Lazy` to rebuild the plugin as needed
			require("blink.cmp").build():pwait()
		end,

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {

			-- press K to see details
			keymap = { preset = "default" },

			signature = {
				trigger = {
					show_on_accept = true,
					show_on_accept_on_trigger_character = true,
				},
				window = { show_documentation = true, border = "rounded" },
				enabled = true,
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				accept = {},
				list = {
					selection = {
						preselect = true,
						auto_insert = false,
					},
				},
				menu = {
					auto_show = false,
					border = "rounded",
					draw = {
						components = {
							kind_icon = {
								text = function(ctx)
									local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
									return kind_icon
								end,
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
							kind = {
								-- (optional) use highlights from mini.icons
								highlight = function(ctx)
									local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
									return hl
								end,
							},
						},
					},
				},
				documentation = {
					auto_show = true,
					window = {
						border = "rounded",
					},
				},
				ghost_text = {
					enabled = true,
					show_without_menu = true,
				},
				trigger = { prefetch_on_insert = false },
			},

			-- (Default) list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = {
					"lsp",
					"path",
					"snippets",
					-- "buffer",
				},
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"`
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
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
				cmp = { enable_auto_complete = false },
				blink = { enable_auto_complete = false },
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
				virtualtext = {
					auto_trigger_ft = {},
					keymap = {
						next = "<C-l>",
						prev = "<C-h>",
						accept = "<C-y>",
						accept_line = "<S-Tab>",
						dismiss = "<C-e>",
					},
				},
			})
		end,
	},
}
