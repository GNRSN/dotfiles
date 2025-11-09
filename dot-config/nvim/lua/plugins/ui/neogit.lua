return {
  -- Interact with git from custom nvim buffers
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
    cmd = {
      "Neogit",
      "NeogitCommit",
      "NeogitLogCurrent",
      "NeogitResetState",
    },
    opts = {
      integrations = {
        telescope = false,
        fzf_lua = false,
        snacks = true,
      },
    },
  },
}
