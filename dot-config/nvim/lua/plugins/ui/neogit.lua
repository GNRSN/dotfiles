return {
  -- Interact with git within nvim
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration

      -- Only one of these is needed.
      "ibhagwan/fzf-lua", -- optional
    },
    cmd = {
      "Neogit",
    },
    config = true,
  },
}
