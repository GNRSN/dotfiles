return {
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = { "Codeium" },
    config = function()
      require("codeium").setup({
        enable_chat = true,
        enable_cmp_source = true,
      })
    end,
  },
}
