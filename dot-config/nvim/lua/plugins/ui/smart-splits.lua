return {
  -- Allows integrating with terminal splits or multiplexer
  {
    "mrjones2014/smart-splits.nvim",
    -- DOC: Lazy loading may cause issues
    lazy = false,
    keys = {
      -- moving between splits
      {
        "<C-h>",
        function()
          require("smart-splits").move_cursor_left()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<C-j>",
        function()
          require("smart-splits").move_cursor_down()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<C-k>",
        function()
          require("smart-splits").move_cursor_up()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<C-l>",
        function()
          require("smart-splits").move_cursor_right()
        end,
        mode = { "n", "i", "x" },
      },
      { -- Jump back, I think this is nice for Avante since cursor ends up in nearest
        -- field by proximity
        "<C-tab>",
        function()
          require("smart-splits").move_cursor_previous()
        end,
        mode = { "n", "i", "x" },
      },

      -- resizing splits
      -- these keymaps will also accept a range,
      -- for example `10<A-h>` will `resize_left` by `(10 * config.default_amount)`
      {
        "<A-h>",
        function()
          require("smart-splits").resize_left()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<A-j>",
        function()
          require("smart-splits").resize_down()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<A-k>",
        function()
          require("smart-splits").resize_up()
        end,
        mode = { "n", "i", "x" },
      },
      {
        "<A-l>",
        function()
          require("smart-splits").resize_right()
        end,
        mode = { "n", "i", "x" },
      },
      -- swapping buffers between windows
      -- vim.keymap.set("n", "<leader><leader>h", require("smart-splits").swap_buf_left)
      -- vim.keymap.set("n", "<leader><leader>j", require("smart-splits").swap_buf_down)
      -- vim.keymap.set("n", "<leader><leader>k", require("smart-splits").swap_buf_up)
      -- vim.keymap.set("n", "<leader><leader>l", require("smart-splits").swap_buf_right)
    },
    opts = {
      -- I wasn't really a fan of wrapping
      at_edge = "stop",

      ignored_filetypes = {
        "neo-tree",
        "neotest",
        "neotest-summary",
        "neotest-output-panel",
        "Trouble",
        "noice",
        "undotree",
        "spectre_panel",
        "octo",
        "DiffviewFiles",
      },
    },
  },
}
