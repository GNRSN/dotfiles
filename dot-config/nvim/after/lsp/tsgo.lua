-- local tsdk = require("util.local-config").get_tsgo_tsdk_from_config()

---@type vim.lsp.Config
return tsdk and { cmd = { tsdk .. "/tsgo", "lsp", "--stdio" } } or {}
