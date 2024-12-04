return {
  -- Navigate directories + vim-like edit to file system
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      {
        "<leader>e",
        function()
          require("oil").toggle_float()
        end,
        desc = "Open parent directory (oil)",
      },
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
      },
      win_options = {
        wrap = true,
        winblend = 0,
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
