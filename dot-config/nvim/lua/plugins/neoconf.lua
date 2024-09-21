return {
  -- Allow file based workspace config similar to & parse vscode settings.json
  {
    "folke/neoconf.nvim",
    -- This needs to run before lsp-config and preferably ASAP
    -- as it's essentially injecting env variables for config
    lazy = false,
    priority = 9001,
    config = function()
      require("neoconf").setup({})
      local format_on_save = require("util.format-on-save")
      format_on_save.init()
    end,
  },
}
