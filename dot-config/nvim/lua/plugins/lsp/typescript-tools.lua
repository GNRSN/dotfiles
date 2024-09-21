return {
  -- Bespoke tsserver wrapper for better TS performance, "native" lua wrapper communicating through the tsserver protocol with predates lsp
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",

      -- Support typescript // ^? query comment
      "marilari88/twoslash-queries.nvim",
    },
    config = function()
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
        settings = {
          -- REVIEW: tsserver and tsdk isn't the same though?
          tsserver_path = require("util.typescript").get_tsdk_from_config(),

          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
