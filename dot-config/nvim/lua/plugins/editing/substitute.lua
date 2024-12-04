return {
  ---@type LazySpec
  {
    "gbprod/substitute.nvim",
    cond = true,
    dependencies = {
      -- Since we use the integration it has to load first
      "gbprod/yanky.nvim",
    },
    event = "VeryLazy",
    keys = {
      {
        "s",
        function()
          require("substitute").operator()
        end,
        mode = "n",
        desc = "Substitute <motion>",
      },
      {
        "ss",
        function()
          require("substitute").line()
        end,
        mode = "n",
        desc = "Substitute line",
      },
      {
        "S",
        function()
          require("substitute").eol()
        end,
        mode = "n",
        desc = "Substitute eol",
      },
      {
        "s",
        function()
          require("substitute").visual()
        end,
        mode = "x",
        desc = "Substitute",
      },
    },
    opts = function()
      return {
        on_substitute = require("yanky.integration").substitute(),
        yank_substituted_text = true,
        preserve_cursor_position = true,
        highlight_substituted_text = {
          enabled = true,
          timer = 200,
        },
      }
    end,
  },
}
