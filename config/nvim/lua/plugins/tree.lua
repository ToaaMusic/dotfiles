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

    config = function()
      require("neo-tree").setup({
        close_if_last_window = false,
        popup_border_style = "NC",
        clipboard = {
          sync = "none", -- or "global"/"universal"
        },
        enable_git_status = true,
        enable_diagnostics = true,

        window = {
          position = "right",
          width = 0.15,
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

      })
    end,

  }
}
