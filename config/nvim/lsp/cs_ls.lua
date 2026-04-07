--- csharp-ls: https://github.com/razzmatazz/csharp-language-server 
---
--- requires the [dotnet-sdk](https://dotnet.microsoft.com/download ) to be installed.
---
--- The preferred way to install csharp-ls is with `dotnet tool install --global csharp-ls`.

---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = vim.fn.expand('~/.dotnet/tools/csharp-ls')
    return vim.lsp.rpc.start({ cmd }, dispatchers, {
      -- csharp-ls attempt to locate sln, slnx or csproj files from cwd, so set cwd to root directory.
      -- If cmd_cwd is provided, use it instead.
      cwd = config.cmd_cwd or config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
  end,

  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, { '.sln', '.slnx', '.csproj' })
    on_dir(root)
  end,

  filetypes = { 'cs' },
  init_options = {
    AutomaticWorkspaceInit = true,
  },
  get_language_id = function(_, ft)
    if ft == 'cs' then
      return 'csharp'
    end
    return ft
  end,
}
