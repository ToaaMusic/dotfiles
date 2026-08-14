local luarc = vim.fs.root(0, { ".luarc.json" })
local luarc_params = {}
if luarc then
	local ok, data = pcall(vim.json.decode, table.concat(vim.fn.readfile(luarc .. "/.luarc.json"), "\n"))
	if ok and data and data["misc.parameters"] then
		luarc_params = data["misc.parameters"]
	end
end

---@type vim.lsp.Config
return {
	cmd = vim.list_extend({ "lua-language-server" }, luarc_params),
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
			codeLens = { enable = true },
			hint = { enable = true },
			completion = {
				enable = true,
				displayContext = 10,
				callSnippet = "Both",
				autoRequire = true,
				-- postfix = "@",
			},
			format = {
				enable = true,
				defaultConfig = {
					indent_style = "tab",
					indent_size = "2",
					align_continuous_rect_table_field = "true"
				}
			},
			hover = {
				enable = true,
				previewFields = 1000,
			},
			type = {
				castNumberToInteger = true,
				-- checkTableShape = false,
				inferParamType = true,
				-- weakNilCheck = true, -- throw when false
				-- weakUnionCheck = false, -- throw when false

			}

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
