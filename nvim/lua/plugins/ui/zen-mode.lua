return {
  {
    "folke/zen-mode.nvim",
    keys = {
      { "<leader>z", "<cmd>ZenMode<cr>", desc = "ZenMode" },
    },
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 0.9,
          width = 140,
        },
      })
    end,
  },
}
