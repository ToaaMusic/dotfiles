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

	settings = {
		Lua = {

			-- format = {
			-- 	enable = true,
			-- 	alignContinuousAssignStatement = true,
			-- 	alignContinuousRectTableField = true,
			-- },

			-- workspace = {
			-- !!：This is global for all nvim instances
			-- if you are not always in nvim dev folder, use .luarc.json instead
			-- 			library = {
			-- 				vim.env.VIMRUNTIME,
			-- 			},
			-- 		},
		},
	},
}
