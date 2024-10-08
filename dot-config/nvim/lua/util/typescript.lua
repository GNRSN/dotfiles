local M = {}

function M.get_tsdk_from_config()
  local neoconf = require("neoconf")
  local vscodeConfig = neoconf.get("vscode.typescript.tsdk") or neoconf.get("typescript.tsdk")

  return vscodeConfig or nil
end

return M
