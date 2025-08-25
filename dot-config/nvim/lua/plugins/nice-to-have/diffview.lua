return {
  -- Displays git diffs using vim diff mode, helps with merge conflicts
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<CR>", mode = "n", desc = "Git diff view" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<CR>", mode = "n", desc = "Git diff view (file history)" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
    end,
  },
}
