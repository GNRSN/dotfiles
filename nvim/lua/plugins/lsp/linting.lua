return {
  -- Allows running lsp-ish tools with an lsp server,
  -- pretty much only needed for cspell now

  ---@type LazyPluginSpec
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      -- NOTE: even with cpell.nvim, spellchecking isn't as good as with the official vscode extension.
      -- It seems to be bundled with dictionaries or does some language based magic?
      -- @see https://github.com/davidmh/cspell.nvim/issues/14
      -- LATER: See if possible to add dictionaries
      "davidmh/cspell.nvim",
      "mason.nvim",
      "jay-babu/mason-null-ls.nvim",
      "nvimtools/none-ls-extras.nvim",
    },
    lazy = true,
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local cspell = require("cspell")
      local mason_null_ls = require("mason-null-ls")
      local nls = require("null-ls")
      local nls_utils = require("null-ls.utils")

      mason_null_ls.setup({
        ensure_installed = {
          "stylua", -- lua formatter
        },
        automatic_installation = true,
      })

      -- configure null_ls
      nls.setup({
        -- add package.json as identifier for root (for typescript monorepos)
        root_dir = nls_utils.root_pattern(".null-ls-root", "Makefile", ".neoconf.json", ".git", "package.json"),
        sources = {
          cspell.diagnostics.with({
            diagnostics_postprocess = function(diagnostic)
              diagnostic.severity = vim.diagnostic.severity["HINT"]
            end,
          }),
          cspell.code_actions,
        },
      })
    end,
  },
}
