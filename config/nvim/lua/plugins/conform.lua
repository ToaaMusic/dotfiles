-- https://github.com/stevearc/conform.nvim
return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		notify_on_error = true,
		notify_no_formatters = true,
		formatters_by_ft = {
			lua = { "stylua" },
			sh = { "shfmt" },
			zsh = { "shfmt" },
			cs = { "csharpier" },
			glsl = { "clang-format" },
			rust = { "rustfmt", lsp_format = "fallback" },
			markdown = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			json = { "prettier" },
			jsonc = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			vue = { "prettier" },
			yaml = { "prettier" }, -- Or "yamlfmt" / "yamllint" if installed
		},
		formatters = {
			-- 	csharpier = {
			-- 		command = "dotnet", -- needs aspnet-runtime
			-- 		args = { "csharpier", "format", "--write-stdout", "--stdin-path", "$FILENAME" },
			-- 		stdin = true,
			-- 	},
		},
	},
}
