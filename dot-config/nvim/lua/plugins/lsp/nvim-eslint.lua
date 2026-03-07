return {
  -- Bespokte eslint LSP setup
  {
    "esmuellert/nvim-eslint",
    config = function()
      require("nvim-eslint").setup({

        settings = {
          codeActionOnSave = nil,
          nodePath = require("neoconf").get("vscode.eslint.nodePath"),
          workingDirectory = require("neoconf").get("vscode.eslint.workingDirectory") or { mode = "auto" },
        },
      })
    end,
  },
}
