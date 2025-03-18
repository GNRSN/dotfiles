return {
  {
    "stevearc/aerial.nvim",
    keys = {
      { "<leader>O", "<cmd>AerialToggle!<CR>", desc = "Toggle outline (Aerial)" },
    },
    cmd = {
      "AerialToggle",
    },
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
}
