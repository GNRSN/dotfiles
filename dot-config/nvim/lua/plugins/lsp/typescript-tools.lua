local function get_ts_server_path()
  local tsdk = require("util.local-config").get_tsdk_from_config()

  if tsdk then
    -- Typescript-tools expect path to tsserver.js, tsserver lsp config only refers to the folder
    return tsdk .. "/tsserver.js"
  end
end

return {
  -- Bespoke tsserver wrapper for better TS performance, "native" lua wrapper communicating through the tsserver protocol which predates lsp
  -- TODO: Get rid of some options from lsp code actions that I never use, they just clutter it
  {
    -- TODO: pmizio/typescript-tools.nvim was no longer maintained?
    "Yuki-bun/typescript-tools.nvim",
    -- Fork using nvim 0.11 native lsp apis
    -- Discussion:
    -- https://github.com/pmizio/typescript-tools.nvim/pull/366
    branch = "refac-use_native_lsp_api",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      -- Support typescript // ^? query comment
      "marilari88/twoslash-queries.nvim",
    },
    config = function()
      local tsserver_path = get_ts_server_path()

      local api = require("typescript-tools.api")

      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
        settings = {
          tsserver_path = tsserver_path,

          jsx_close_tag = {
            -- REVIEW: May interfere with other autotag plugins
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
        -- LATER: Try to implement custom handler to filter out worthless refactoring actions
        handlers = {
          -- LSP Handler should vim.notify dump list of available actions
          ["textDocument/codeAction"] = function(err, result, ctx, config)
            vim.notify("custom textDocument/codeAction handler")
            vim.notify(vim.inspect(result))
          end,
          -- ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
          --   vim.notify("custom textDocument/publishDiagnostics handler")
          --   vim.notify(vim.inspect(result))
          -- end,
          ["textDocument/publishDiagnostics"] = api.filter_diagnostics(
            -- Ignore "Merge conflict marker encountered"
            { 1185 }
          ),
        },
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    dependencies = {
      "rcarriga/nvim-notify",
      "folke/trouble.nvim",
    },
    cmd = {
      "TSC",
    },
    opts = {
      use_trouble_qflist = true,
    },
  },

  {
    "dmmulroy/ts-error-translator.nvim",
    -- LATER: I have not been very impressed with error translator
    -- I'd like to activate it with some keybind or something since it often just adds extra text for nothing
    opt = {},
  },
}
