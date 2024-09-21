-- Results in stripe pattern for removed lines
vim.opt.fillchars:append({ diff = "╱" })

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
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true,
      })
    end,
  },
}
