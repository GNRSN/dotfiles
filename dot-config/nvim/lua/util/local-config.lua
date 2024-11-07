local M = {}

M.defaults = {
  format_on_save = true,
  allow_project_tsdk = false,
  graphite = false,
}

M.is_init = false

function M.get_workspace_config()
  if not M.is_init then
    error("workspace_config not parsed yet")
  end
  return require("neoconf").get("workspace-config", M.defaults)
end

function M.init()
  if M.is_init then
    error("local-config: Already initialized")
  end

  require("neoconf.plugins").register({
    name = "workspace-config",
    on_schema = function(schema)
      -- this call will create a json schema based on the lua types of your default settings
      schema:import("workspace-config", M.defaults)
    end,
  })

  M.is_init = true

  local workspace_config = M.get_workspace_config()

  vim.g.format_on_save = workspace_config.format_on_save
end

function M.get_tsdk_from_config()
  local vscodeConfig = require("neoconf").get("vscode.typescript.tsdk")

  if not M.get_workspace_config().allow_project_tsdk then
    if vscodeConfig then
      vim.notify("Project configuration contains custom typescript.tsdk but allow_project_tsdk isn't set")
    end
    return nil
  end

  return vscodeConfig or nil
end

function M.is_work_dir()
  local work_dir = vim.env.WORK_DIR
  if not work_dir then
    vim.notify("env.WORK_DIR not set")
    return true
  end
  return vim.fn.getcwd():find(work_dir, 1, true) ~= nil
end

return M
