-- Change the Diagnostic symbols
local signs = require("config.CMP").icons.diagnostics

vim.diagnostic.config({
  virtual_text = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
  ---@type vim.diagnostic.Opts.Signs
  signs = {
    severity = { min = vim.diagnostic.severity.WARN },
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.INFO] = signs.Info,
      [vim.diagnostic.severity.HINT] = signs.Hint,
    },
    numhl = {
      -- [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      -- [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      -- [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      -- [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
    linehl = {
      -- [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
      -- [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
      -- [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
      -- [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
    },
  },
  underline = {
    severity = { min = vim.diagnostic.severity.WARN },
  },
})
