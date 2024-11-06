return {
  -- Allow file based workspace config similar to & parse vscode settings.json
  {
    "folke/neoconf.nvim",
    -- This needs to run before lsp-config and preferably ASAP
    -- as it's essentially injecting env variables for config
    lazy = false,
    priority = 9001,
    config = function()
      require("neoconf").setup({
        import = {
          vscode = true,
        },
      })
      require("util.local-config").init()
    end,
  },
}
