return {
  {
    "uga-rosa/ccc.nvim",
    config = function()
      -- Enable true color
      vim.opt.termguicolors = true

      local ccc = require("ccc")

      ccc.setup({
        highlighter = {
          auto_enable = true,
          lsp = true,
        },
        mappings = {
          ["<Esc>"] = ccc.mapping.quit,
        },
        inputs = {
          ccc.input.hsl,
          ccc.input.rgb,
        },
        point_char = "",
        bar_len = 42,
      })
    end,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>cp", "<cmd>CccPick<cr>", desc = "Open color picker" },
    },
  },
}
