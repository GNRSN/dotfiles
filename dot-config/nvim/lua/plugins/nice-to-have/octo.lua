return {
  -- UI for github cli, supported by cheatsheets
  {
    "pwntester/octo.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup({
        picker = "fzf-lua",
        picker_config = {
          use_emojis = true,
        },
        suppress_missing_scope = {
          projects_v2 = true,
        },
      })

      vim.treesitter.language.register("markdown", "octo")
    end,
  },
}
