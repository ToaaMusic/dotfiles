-- https://github.com/stevearc/conform.nvim
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
			rust = { "rustfmt", lsp_format = "fallback" },
			cs = { "csharpier" },
		},
		-- formatters = {
		-- 	csharpier = {
		-- 		command = "dotnet", -- needs aspnet-runtime
		-- 		args = { "csharpier", "format", "--write-stdout", "--stdin-path", "$FILENAME" },
		-- 		stdin = true,
		-- 	},
		-- },
	},
}
