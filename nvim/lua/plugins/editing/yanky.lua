return {
  -- Better yanking with history, ctrl p/n to replace with previous yank after putting
  {
    "gbprod/yanky.nvim",
    opts = {
      preserve_cursor_position = {
        enabled = true,
      },
      highlight = {
        timer = 200,
      },
    },
    keys = {
      -- Basic usage
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yanky yank" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Yanky put (after)" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Yanky put (before)" },
      -- Interfers with goto preview
      -- { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Yanky G-put (after)" },
      -- { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Yanky G-put (before)" },
      -- NOTE: Flipped n and p because this is more intuitive for me
      { "<c-n>", "<Plug>(YankyPreviousEntry)", desc = "Yanky previous entry" },
      { "<c-p>", "<Plug>(YankyNextEntry)", desc = "Yanky next entry" },
      -- Tpope/vim-unimpaired 'esque usage
      { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yanky put indent after linewise" },
      { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yanky put indent before linewise" },
      { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Yanky put indent after linewise" },
      { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Yanky put indent before linewise" },

      { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Yanky put indent after linewise" },
      { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Yanky put indent after linewise" },
      { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Yanky put indent after linewise" },
      { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Yanky put indent after linewise" },

      { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Yanky put indent after linewise" },
      { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Yanky put indent after linewise" },
      -- History
      { "<leader>sp", "<cmd>Telescope yank_history<cr>", desc = "Yanky clipboard" },
    },
  },
}
