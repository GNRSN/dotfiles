return {
  -- Inline markdown renderer
  -- LATER: There is also an markdown *lsp* https://github.com/artempyanykh/marksman
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = { file_types = { "markdown", "Avante" } },
    ft = { "markdown", "Avante" },
  },
}
