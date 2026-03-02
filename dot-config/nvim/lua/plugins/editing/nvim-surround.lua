return {
  -- Wrap text
  {
    -- NOTE: There is an issue with which-key interrupting some of the initial keymaps
    -- see: https://github.com/kylechui/nvim-surround/issues/354#issuecomment-2466428157
    "kylechui/nvim-surround",
    event = "VeryLazy",
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = {},
  },
  -- Which-key based guide for nvim-surround
  {
    "roobert/surround-ui.nvim",
    event = "VeryLazy",
    dependencies = {
      "kylechui/nvim-surround",
      "folke/which-key.nvim",
    },
    config = function()
      require("surround-ui").setup({
        root_key = "S",
      })
    end,
  },
}
