return {
  ---@type LazySpec
  {
    "gbprod/substitute.nvim",
    config = function()
      require("substitute").setup({
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
      })

      local keymap = vim.keymap

      keymap.set("n", "s", require("substitute").operator, { noremap = true })
      keymap.set("n", "ss", require("substitute").line, { noremap = true })
      keymap.set("n", "S", require("substitute").eol, { noremap = true })
      keymap.set("x", "s", require("substitute").visual, { noremap = true })
    end,
  },
}
