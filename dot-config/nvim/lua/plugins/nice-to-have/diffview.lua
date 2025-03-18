return {
  -- Displays git diffs using vim diff mode, helps with merge conflicts
  {
    "sindrets/diffview.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "DiffviewOpen",
    },
    keys = {
      { "<leader>gd", ":DiffviewOpen<cr>", mode = "n", desc = "Git diff view" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
    end,
  },
}
