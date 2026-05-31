return {
	-- {
	-- 	"rmagatti/auto-session",
	-- 	lazy = false,
	--
	-- 	---enables autocomplete for opts
	-- 	---@module "auto-session"
	-- 	---@type AutoSession.Config
	-- 	opts = {
	-- 		suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	-- 		-- log_level = 'debug',
	-- 	},
	-- },

	-- https://github.com/folke/snacks.nvim
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		---@type snacks.Config
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			animate = { enabled = true },
			input = { enabled = true },
			picker = { enabled = true },
			scroll = { enabled = true },
			indent = {
				enabled = true,
				only_scope = false,
				only_current = true,
				---@param buf number
				---@param win number
				---@diagnostic disable-next-line: unused-local
				filter = function(buf, win)
					return vim.g.snacks_indent ~= false
						and vim.b[buf].snacks_indent ~= false
						and vim.bo[buf].buftype == ""
						and vim.bo[buf].filetype ~= "markdown"
				end,
				chunk = {
					enabled = true,
					char = {
						corner_top = "┌",
						corner_bottom = "└",
						horizontal = "─",
						vertical = "│",
						arrow = ">",
					},
				},
			},
			dashboard = { enabled = true },
		},
	},
	{
		"GustavEikaas/easy-dotnet.nvim",
		-- 'nvim-telescope/telescope.nvim' or 'ibhagwan/fzf-lua' or 'folke/snacks.nvim'
		-- are highly recommended for a better experience
		dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap", "folke/snacks.nvim" },
		config = function()
			local dotnet = require("easy-dotnet")
			-- Options are not required
			dotnet.setup({
				managed_terminal = {
					auto_hide = true, -- auto hides terminal if exit code is 0
					auto_hide_delay = 1000, -- delay before auto hiding, 0 = instant
					mappings = {
						next_tab = { lhs = "<Tab>", desc = "Next terminal tab" },
						prev_tab = { lhs = "<S-Tab>", desc = "Previous terminal tab" },
						new_terminal = { lhs = "+", desc = "New user terminal" },
						close_terminal = { lhs = "X", desc = "Close current terminal tab" },
						hide_panel = { lhs = "q", desc = "Hide terminal panel" },
					},
				},
				-- Optional configuration for external terminals (matches nvim-dap structure)
				external_terminal = nil,
				projx_lsp = {
					enabled = true,
				},
				lsp = {
					enabled = true, -- Enable builtin roslyn lsp
					set_fold_expr = false,
					preload_roslyn = true, -- Start loading roslyn before any buffer is opened
					roslynator_enabled = true, -- Automatically enable roslynator analyzer
					easy_dotnet_analyzer_enabled = true, -- Enable roslyn analyzer from easy-dotnet-server
					auto_refresh_codelens = true,
					suggest_updates = true, -- Periodically suggest roslyn-language-server updates
					analyzer_assemblies = {}, -- Any additional roslyn analyzers you might use like SonarAnalyzer.CSharp
					razor = {
						enabled = true,
						html = {
							enabled = true,
							cmd = nil, -- Auto-detect project node_modules/.bin/vscode-html-language-server, then PATH
							request_timeout = 5000,
						},
					},
					config = {},
				},
				debugger = {
					-- Path to custom coreclr DAP adapter
					-- easy-dotnet-server falls back to its own netcoredbg binary if bin_path is nil
					bin_path = nil,
					console = "integratedTerminal", -- Controls where the target app runs: "integratedTerminal" (Neovim buffer) or "externalTerminal" (OS window)
					apply_value_converters = true,
					auto_register_dap = true,
					mappings = {
						open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
					},
				},
				---@type TestRunnerOptions
				test_runner = {
					auto_start_testrunner = true,
					hide_legend = false,
					-- Set to true when using neotest to avoid duplicate signs and conflicting buffer keymaps.
					neotest_integration = false,
					---@type "split" | "vsplit" | "float" | "buf"
					viewmode = "float",
					---@type number|nil
					vsplit_width = nil,
					---@type string|nil "topleft" | "topright"
					vsplit_pos = nil,
					icons = {
						passed = "",
						skipped = "",
						failed = "",
						success = "",
						reload = "",
						test = "",
						sln = "󰘐",
						project = "󰘐",
						dir = "",
						package = "",
						class = "",
						build_failed = "󰒡",
					},
					mappings = {
						run_test_from_buffer = { lhs = "<leader>r", desc = "run test from buffer" },
						run_all_tests_from_buffer = { lhs = "<leader>t", desc = "Run all tests in file" },
						get_build_errors = { lhs = "<leader>e", desc = "get build errors" },
						peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "peek stack trace from buffer" },
						debug_test_from_buffer = { lhs = "<leader>d", desc = "run test from buffer" },
						debug_test = { lhs = "<leader>d", desc = "debug test" },
						go_to_file = { lhs = "g", desc = "go to file" },
						run_all = { lhs = "<leader>R", desc = "run all tests" },
						run = { lhs = "<leader>r", desc = "run test" },
						peek_stacktrace = { lhs = "<leader>p", desc = "peek stacktrace of failed test" },
						expand = { lhs = "o", desc = "expand" },
						expand_node = { lhs = "E", desc = "expand node" },
						collapse_all = { lhs = "W", desc = "collapse all" },
						close = { lhs = "q", desc = "close testrunner" },
						refresh_testrunner = { lhs = "<C-r>", desc = "refresh testrunner" },
						cancel = { lhs = "<C-c>", desc = "cancel in-flight operation" },
					},
				},
				new = {
					project = {
						prefix = "sln", -- "sln" | "none"
					},
				},
				csproj_mappings = true,
				fsproj_mappings = true,
				auto_bootstrap_namespace = {
					--block_scoped, file_scoped
					type = "block_scoped",
					enabled = true,
					use_clipboard_json = {
						behavior = "prompt", --'auto' | 'prompt' | 'never',
						register = "+", -- which register to check
					},
				},
				server = {
					---@type nil | "Off" | "Critical" | "Error" | "Warning" | "Information" | "Verbose" | "All"
					log_level = nil,
				},
				-- choose which picker to use with the plugin
				-- possible values are "telescope" | "fzf" | "snacks" | "basic"
				-- if no picker is specified, the plugin will determine
				-- the available one automatically with this priority:
				--  snacks -> fzf -> telescope ->  basic
				picker = "snacks",
				notifications = {
					--Set this to false if you have configured lualine to avoid double logging
					handler = function(start_event)
						local spinner = require("easy-dotnet.ui-modules.spinner").new()
						spinner:start_spinner(start_event.job.name)
						---@param finished_event JobEvent
						return function(finished_event)
							spinner:stop_spinner(finished_event.result.msg, finished_event.result.level)
						end
					end,
				},
				diagnostics = {
					default_severity = "error",
					setqflist = false,
				},
				outdated = {
					mappings = {
						upgrade = { lhs = "<leader>pu", desc = "upgrade package under cursor" },
						upgrade_all = { lhs = "<leader>pa", desc = "upgrade all outdated packages" },
					},
				},
			})

			-- Example command
			vim.api.nvim_create_user_command("Secrets", function()
				dotnet.secrets()
			end, {})

			-- Example keybinding
			vim.keymap.set("n", "<C-p>", function()
				dotnet.run_project()
			end)
		end,
	},
}
