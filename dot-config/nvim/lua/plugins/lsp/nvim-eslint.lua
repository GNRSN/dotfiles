return {
  -- Bespoke eslint LSP setup
  -- comes bundled with a newer version of eslint lsp implementation from vscode-languageservers-extracted,
  -- and uses project local eslint binary => no need to install anything through Mason
  {
    "esmuellert/nvim-eslint",
    config = function()
      if require("neoconf").get("vscode.eslint.enable") then
        require("nvim-eslint").setup({
          settings = {
            codeActionOnSave = nil,
            nodePath = require("neoconf").get("vscode.eslint.nodePath"),
            workingDirectory = require("neoconf").get("vscode.eslint.workingDirectory") or { mode = "auto" },
          },
        })
      end
    end,
  },
}
