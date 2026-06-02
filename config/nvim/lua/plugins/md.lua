return {
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim
	"MeanderingProgrammer/render-markdown.nvim",
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.nvim" }, -- if you use the mini.nvim suite
	dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" }, -- if you use standalone mini plugins
	-- dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
	ft = "markdown",
	---@module 'render-markdown'
	---@type render.md.UserConfig
	opts = {
		render_modes = { "n", "i" },
		-- all the "sign" means at the left of gutter
		-- such as the lang icon of code blocks, i'll disable
		sign = { enabled = false },
		-- raw text in cursor line
		anti_conceal = {
			enabled = true,
			disabled_modes = { "n" },
			above = 1,
			below = 1,
			-- ignore = {},
		},
		-- https://github.com/MeanderingProgrammer/render-markdown.nvim/wiki
		-- " # "
		heading = {
			position = "inline",
			sign = false,
			icons = { "", "", "", "", "", "" }, -- { '🔴 ', '🟠 ', '🟡 ', '🟢 ', '🔵 ', '🟣 ' },
			-- border options
			border = false,
			border_virtual = true,
			above = "",
			below = "─",
		},
		-- " ``` ``` "
		code = {
			render_modes = { "n" },
			width = "block",
      min_width = 60,
      -- left_pad = 2,
      -- right_pad = 2,
      conceal_delimiters = false,
			language = true,
		},

		-- " - " list
		bullet = {
			icons = { " • ", " ◦ ", " ▪ ", " ▫ " },
		},

		-- " - [ ] "
		checkbox = {
			unchecked = { icon = " ✘ " },
			checked = { icon = " ✔ " },
			custom = { todo = { rendered = " ◯ " } },
		},

		-- " > "
		quote = { icon = "│" },

		-- " > [!NOTE] "
		callout = {},

		-- " --- "
		dash = { width = 60 },

		overrides = {
			buftype = {
				nofile = {
					enabled = true, -- render in K floating doc panal or not
				},
			},
		},
		enabled = true,
	},
}
