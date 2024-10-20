local function get_ts_server_path()
  local tsdk = require("util.typescript").get_tsdk_from_config()

  if tsdk then
    -- Typescript-tools expect path to tsserver.js, tsserver lsp config only refers to the folder
    return tsdk .. "/tsserver.js"
  end
end

return {
  -- Bespoke tsserver wrapper for better TS performance, "native" lua wrapper communicating through the tsserver protocol which predates lsp
  -- LATER: Get rid of some options from lsp code actions that I never use, they just clutter it
  {
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      -- Support typescript // ^? query comment
      "marilari88/twoslash-queries.nvim",
    },
    config = function()
      -- REVIEW: This is a bit scary, vscode forces opt in per project since it's a security risk. Consider something similar
      local tsserver_path = get_ts_server_path()
      if tsserver_path then
        vim.notify("Typescript-tools running with custom project tsserver found at: " .. tsserver_path)
      end

      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          require("twoslash-queries").attach(client, bufnr)
        end,
        settings = {
          tsserver_path = tsserver_path,

          jsx_close_tag = {
            -- REVIEW: May interfer with other autotag plugins
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
