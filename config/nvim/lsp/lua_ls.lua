---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".emmyrc.json",
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
		".git",
	},
	-- capabilities = {
	-- 	textDocument = {
	-- 		foldingRange = {
	-- 			dynamicRegistration = false,
	-- 			lineFoldingOnly = true,
	-- 		},
	-- 	},
	-- },

	-- 注意：这里设置的是全局引用
	-- 非全局不推荐在这里写而是使用 .luarc.json
	-- 但是如果项目存在 .luarc.json, 这里将不会被加载

	-- settings = {
	-- 	Lua = {
	-- 		workspace = {
	-- 			library = {
	-- 				vim.env.VIMRUNTIME,
	-- 			},
	-- 		},
	-- 	},
	-- },
}
