return {
  {
    -- "Zoom" splits, including animations
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    event = "VeryLazy",
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require("windows").setup({
        ignore = {
          buftype = {
            "quickfix",
          },
          filetype = {
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
            "aerial",
          },
        },
      })
    end,
  },
}
