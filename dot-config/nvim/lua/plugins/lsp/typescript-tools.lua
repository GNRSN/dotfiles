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
    "pmizio/typescript-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      -- Support typescript // ^? query comment
      "marilari88/twoslash-queries.nvim",
    },
    config = function()
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
    cond = false,
    config = function()
      require("ts-error-translator").setup()
    end,
  },
}
