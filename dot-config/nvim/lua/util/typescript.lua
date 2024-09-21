local M = {}

function M.get_tsdk_from_config()
  local vscodeConfig = require("neoconf").get("vscode.typescript.tsdk")

  return vscodeConfig or nil
end

return M
