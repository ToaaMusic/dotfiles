vim.lsp.enable({
	"rust_analyzer",
	"lua_ls",
	-- "roslyn_ls",
	"clangd",
	"vtsls",
	"vue",
	"glsl",
	"bashls",
	"jsonls",
	"lemminx"
})

---@type vim.diagnostic.Opts
local diagnosticConfig = {
	update_in_insert = false,
	virtual_text = {
		prefix = "● ",
		source = "if_many",
	},
	virtual_lines = {
		current_line = true,
	},
}

vim.diagnostic.config(diagnosticConfig)
