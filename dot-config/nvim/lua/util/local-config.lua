local M = {}

M.defaults = {
  format_on_save = true,
  allow_project_tsdk = false,
  graphite = false,
  custom_filetypes = {},
}

M.is_init = false

function M.get_workspace_config()
  if not M.is_init then
    error("workspace_config not parsed yet")
  end
  return require("neoconf").get("workspace-config", M.defaults)
end

function M.is_allow_project_tsdk()
  return M.get_workspace_config().allow_project_tsdk
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

  -- LATER: Also read vscode/settings.json files.associations field
  vim.filetype.add(workspace_config.custom_filetypes)

  vim.api.nvim_create_user_command("AllowProjectTsdk", function(opts)
    local arg = vim.trim(opts.args):lower()
    local new_value
    if arg == "" then
      new_value = not M.is_allow_project_tsdk()
    elseif arg == "true" then
      new_value = true
    elseif arg == "false" then
      new_value = false
    else
      vim.notify(
        "AllowProjectTsdk: expected true, false, or no argument (got " .. opts.args .. ")",
        vim.log.levels.ERROR
      )
      return
    end

    local util = require("neoconf.util")
    local Settings = require("neoconf.settings")
    local file = vim.fn.getcwd() .. "/.neoconf.json"

    local settings = Settings.new():load(file)
    settings:set("workspace-config.allow_project_tsdk", new_value)
    util.write_file(file, util.json_format(settings._settings))
    Settings.clear(util.fqn(file))

    vim.notify("allow_project_tsdk = " .. tostring(new_value) .. " (" .. file .. ")")
  end, {
    nargs = "?",
    complete = function()
      return { "true", "false" }
    end,
    desc = "Set/toggle allow_project_tsdk in the project's .neoconf.json",
  })
end

function M.get_tsdk_from_config()
  local vscodeConfig = require("neoconf").get("vscode.typescript.tsdk")

  if not M.is_allow_project_tsdk() then
    if vscodeConfig then
      vim.notify("Project configuration contains custom typescript.tsdk but allow_project_tsdk isn't set")
    end
    return nil
  end

  return vscodeConfig or nil
end

function M.use_tsgo()
  return require("neoconf").get("vscode.js/ts.experimental.useTsgo") == true
end

function M.get_tsgo_tsdk_from_config()
  local vscodeConfig = require("neoconf").get("vscode.typescript.native-preview.tsdk")

  if not M.is_allow_project_tsdk() then
    if vscodeConfig then
      vim.notify(
        "Project configuration contains custom typescript.native-preview.tsdk but allow_project_tsdk isn't set"
      )
    end
    return nil
  end

  if not vscodeConfig then
    return nil
  end

  -- VS Code resolves a relative tsdk against the workspace root
  if vscodeConfig:sub(1, 1) ~= "/" then
    local root = require("neoconf.workspace").find_root({})
    vscodeConfig = vim.fs.joinpath(root, vscodeConfig)
  end

  return vscodeConfig
end

function M.is_work_dir()
  local work_dir = vim.env.WORK_DIR
  if not work_dir then
    vim.notify("env.WORK_DIR not set")
    return true
  end
  return vim.fn.getcwd():find(work_dir, 1, true) ~= nil
end

function M.is_prettier_enabled()
  return require("neoconf").get("vscode.prettier.enable")
end

return M
