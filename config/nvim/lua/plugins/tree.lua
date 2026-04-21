return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons", -- optional, but recommended
    },
    lazy = false,
    ---@module 'neo-tree'
    ---@type neotree.Config
    opts = {
      close_if_last_window = false,
      popup_border_style = "NC",
      clipboard = {
        sync = "none",   -- 不同 Neovim 实例之间不共享剪贴板 or "global"/"universal"
      },
      enable_git_status = true,
      enable_diagnostics = true,

      window = {
        position = "right",
        width = 0.15,
        mappings = {
          ["h"] = "close_node",
          ["l"] = "open",
          ["pl"] = "focus_preview",
        }
      },

      -- different window types
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols"
      },

      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },

      document_symbols = {
        follow_cursor = true,
        follow_tree_cursor = true,
      },


    }
  }
}
