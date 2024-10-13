return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>A", "<cmd>AerialToggle!<CR>", desc = "Toggle outline (Aerial)" },
    },
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
