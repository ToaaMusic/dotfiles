return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		formatters_by_ft = {
			javascript = { "prettier" },
			typescript = { "prettier" },
			json = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			markdown = { "prettier" },
			lua = { "stylua" },
			yaml = { "prettier" }, -- Or "yamlfmt" / "yamllint" if installed
		},
	},
}
