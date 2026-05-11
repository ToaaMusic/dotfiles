--- ts_ls: https://github.com/typescript-language-server/typescript-language-server
---
--- Install:
---   npm install -g typescript typescript-language-server @vue/typescript-plugin

---@type vim.lsp.Config
return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
	init_options = {
		hostInfo = "neovim",
		plugins = {
			{
				name = "@vue/typescript-plugin",
				location = vim.fn.system({ "npm", "root", "-g" }):gsub("%s+", "") .. "/@vue/typescript-plugin",
				languages = { "javascript", "typescript", "vue" },
			},
		},
	},
	single_file_support = true,
}
