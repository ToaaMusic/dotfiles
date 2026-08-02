---@type vim.lsp.Config
return {
	cmd = { 'vtsls', '--stdio' },
	init_options = { hostInfo = 'neovim' },
	filetypes = {
		'javascript',
		'javascriptreact',
		'javascript.jsx',
		'typescript',
		'typescriptreact',
		'typescript.tsx',
		'vue',
	},
	root_markers = { 'package-lock.json', 'pnpm-lock.yaml', '.git' },
	on_init = function(client)
		local npm_root = vim.fn.systemlist({ 'npm', 'root', '-g' })[1]
		client.config.settings = client.config.settings or {}
		client.config.settings.vtsls = {
			tsserver = {
				globalPlugins = {
					{
						name = '@vue/typescript-plugin',
						location = npm_root .. '/@vue/language-server',
						languages = { 'vue' },
						configNamespace = 'typescript',
					},
				},
			},
		}
		client:notify('workspace/didChangeConfiguration', {
			settings = client.config.settings,
		})
	end,
}
