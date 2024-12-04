return {
  ---@type LazySpec
  {
    "gbprod/substitute.nvim",
    cond = false,
    keys = {
      {
        "s",
        function()
          require("substitute").operator()
        end,
        mode = "n",
      },
      {
        "ss",
        function()
          require("substitute").line()
        end,
        mode = "n",
      },
      {
        "S",
        function()
          require("substitute").eol()
        end,
        mode = "n",
      },
      {
        "s",
        function()
          require("substitute").visual()
        end,
        mode = "x",
      },
    },
    opts = {
      on_substitute = require("yanky.integration").substitute(),
      -- Rest ar defaults
      yank_substituted_text = false,
      preserve_cursor_position = false,
      modifiers = nil,
      highlight_substituted_text = {
        enabled = true,
        timer = 500,
      },
      range = {
        -- REVIEW: Does this conflict with Surround?
        prefix = "s",
        prompt_current_text = false,
        confirm = false,
        complete_word = false,
        subject = nil,
        range = nil,
        suffix = "",
        auto_apply = false,
        cursor_position = "end",
      },
      exchange = {
        motion = false,
        use_esc_to_cancel = true,
        preserve_cursor_position = false,
      },
    },
  },
}
