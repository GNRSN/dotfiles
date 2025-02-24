return {
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = {
      show_ignored = true,
      symbols = {
        index = {
          [" "] = "-",
        },
        working_tree = {
          [" "] = "-",
        },
      },
    },
  },
  -- Navigate directories + vim-like edit to file system
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "<BS>",
        -- LATER: Would it be possible to open in buffer unless splits?
        function()
          require("oil").toggle_float()
        end,
        desc = "Open parent directory (oil)",
      },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".."
          -- or name == ".git"
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
        win_options = {
          winhighlight = "FloatTitle:OilFloatTitle",
        },
      },
      win_options = {
        -- Required for oil-git-status
        signcolumn = "yes:2",
        wrap = true,
        winblend = 0,
        relativenumber = false,
        number = false,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["<C-h>"] = false,
        ["q"] = "actions.close",
        ["<esc>"] = { "actions.close", mode = "n", desc = "Close" },
        ["<BS>"] = "actions.parent",
      },
    },
  },
}
