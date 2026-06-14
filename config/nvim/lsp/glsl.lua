---@type vim.lsp.Config
return {
	cmd = { "glslls", "--stdin" },
	filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
	root_markers = { ".git" },
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { "utf-8", "utf-16" },
	},
}
-- return {
-- 	cmd = { "glsl_analyzer" },
-- 	filetypes = { "glsl", "vert", "tesc", "tese", "frag", "geom", "comp" },
-- 	root_markers = { ".git" },
-- 	capabilities = {},
-- }
