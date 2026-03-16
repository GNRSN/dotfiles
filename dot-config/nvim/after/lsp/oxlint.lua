local oxc_enabled = require("neoconf").get("vscode.oxc.enable")
local oxlint_enabled = require("neoconf").get("vscode.oxlint.enable")
local enabled = oxlint_enabled or (oxc_enabled and oxlint_enabled ~= false)

---@type vim.lsp.Config
return {
  enabled = enabled,
}
