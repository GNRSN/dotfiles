-- Change the Diagnostic symbols
local diagnostic_signs = require("config.CMP").diagnostic_signs

local M = {}

---@type vim.diagnostic.Opts.VirtualLines
M.virtual_lines_config = {
  severity = { min = vim.diagnostic.severity.WARN },
  current_line = true,
  format = function(diagnostic)
    return string.format(
      "%s(%s) %s",
      diagnostic_signs[diagnostic.severity],
      diagnostic.source or "?",
      diagnostic.message
    )
  end,
}

---@type vim.diagnostic.Opts.VirtualText
M.virtual_text_config = {
  spacing = 2,
  prefix = "",
  format = function(diagnostic)
    return diagnostic_signs[diagnostic.severity] .. diagnostic.message
  end,
  severity = { min = vim.diagnostic.severity.WARN },
}

M.reset = function()
  vim.diagnostic.config({
    virtual_text = M.virtual_text_config,
    ---@type vim.diagnostic.Opts.Signs
    signs = {
      severity = { min = vim.diagnostic.severity.WARN },
      text = diagnostic_signs,
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
    severity_sort = true,
  })
end

return M
