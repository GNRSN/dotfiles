local BLACKLIST_FT = {
  "neo-tree",
  "neotest",
  "neotest-summary",
  "neotest-output-panel",
  "Trouble",
  "trouble",
  "noice",
  "undotree",
  "spectre_panel",
  "octo",
  "DiffviewFiles",
  "aerial",
  "Avante",
  "AvanteInput",
}

local BLACKLIST_BT = {
  "quickfix",
}

return {
  {
    -- "Zoom" splits, including animations
    "anuvyklack/windows.nvim",
    -- Disable for now, works poorly with avante
    cond = false,
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim",
    },
    event = "VeryLazy",
    opts = {
      ignore = {
        buftype = BLACKLIST_BT,
        filetype = BLACKLIST_FT,
      },
    },
    setup = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
    end,
  },
}
