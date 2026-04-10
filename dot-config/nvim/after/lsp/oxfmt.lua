---@type vim.lsp.Config
return {
  enabled = not require("util.local-config").is_prettier_enabled(),
}
