--- Volar: https://github.com/vuejs/language-tools/tree/master/packages/language-server
---
--- Volar by default supports Vue 3 projects.
--- Hybrid mode: Volar handles CSS/HTML, ts_ls handles TypeScript.
--- Install:
---   npm install -g @vue/language-server

---@type vim.lsp.Config
return {
  cmd = { 'vue-language-server', '--stdio' },
  filetypes = { 'vue' },
  root_markers = { 'package.json', '.git' },
  init_options = {
    typescript = {
      tsdk = '',
    },
  },
  on_new_config = function(new_config, new_root_dir)
    if
      new_config.init_options
      and new_config.init_options.typescript
      and new_config.init_options.typescript.tsdk == ''
    then
      local lib_path = vim.fs.find('node_modules/typescript/lib', { path = new_root_dir, upward = true })[1]
      if lib_path then
        new_config.init_options.typescript.tsdk = lib_path
      end
    end
  end,
}
