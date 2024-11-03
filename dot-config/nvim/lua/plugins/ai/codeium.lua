return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    cmd = { "Codeium" },
    config = function()
      require("codeium").setup({
        enable_chat = true,
        enable_cmp_source = true,
      })
    end,
  },
}
