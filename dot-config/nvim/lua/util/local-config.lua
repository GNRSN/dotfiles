local M = {}

M.defaults = {
  format_on_save = true,
  allow_project_tsdk = false,
  prefer_jj = false,
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

-- True when the current repo is tracked by Graphite. Mirrors the detection in
-- lazygit-router.sh (a `.gt` dir inside the resolved git-dir). Shells out to
-- git, so it has no dependency on neoconf/init and works from any cwd in the
-- repo (handles worktrees/submodules via --absolute-git-dir).
function M.is_graphite()
  local git_dir = vim.fn.system({ "git", "rev-parse", "--absolute-git-dir" })
  if vim.v.shell_error ~= 0 then
    return false
  end
  return vim.fn.isdirectory(vim.trim(git_dir) .. "/.gt") == 1
end

-- Cached result of the pre-neoconf .neoconf.json parse
local early_workspace_config = nil

-- Read workspace-config straight from .neoconf.json, bypassing neoconf.
-- lazy.nvim evaluates `cond` during spec resolution, before any plugin
-- (including neoconf) has loaded, so this can't go through neoconf's API.
-- Plain JSON only — vim.json.decode can't handle jsonc comments.
local function read_workspace_config_early()
  if early_workspace_config ~= nil then
    return early_workspace_config
  end
  early_workspace_config = {}

  local found = vim.fs.find({ ".neoconf.json", "neoconf.json" }, { upward = true, path = vim.fn.getcwd() })
  if not found[1] then
    return early_workspace_config
  end

  local fd = io.open(found[1], "r")
  if not fd then
    return early_workspace_config
  end
  local content = fd:read("*a")
  fd:close()

  local ok, json = pcall(vim.json.decode, content)
  if ok and type(json) == "table" and type(json["workspace-config"]) == "table" then
    early_workspace_config = json["workspace-config"]
  end

  return early_workspace_config
end

-- Safe to call before init (e.g. in a lazy.nvim `cond`)
function M.prefer_jj()
  if M.is_init then
    return M.get_workspace_config().prefer_jj
  end
  local value = read_workspace_config_early().prefer_jj
  if value == nil then
    return M.defaults.prefer_jj
  end
  return value
end


-- Set/toggle a boolean workspace-config key in the project's .neoconf.json
local function create_boolean_setting_command(command, key, get_current)
  vim.api.nvim_create_user_command(command, function(opts)
    local arg = vim.trim(opts.args):lower()
    local new_value
    if arg == "" then
      new_value = not get_current()
    elseif arg == "true" then
      new_value = true
    elseif arg == "false" then
      new_value = false
    else
      vim.notify(command .. ": expected true, false, or no argument (got " .. opts.args .. ")", vim.log.levels.ERROR)
      return
    end

    local util = require("neoconf.util")
    local Settings = require("neoconf.settings")
    local file = vim.fn.getcwd() .. "/.neoconf.json"

    local settings = Settings.new():load(file)
    settings:set("workspace-config." .. key, new_value)
    util.write_file(file, util.json_format(settings._settings))
    Settings.clear(util.fqn(file))

    vim.notify(key .. " = " .. tostring(new_value) .. " (" .. file .. ")")
  end, {
    nargs = "?",
    complete = function()
      return { "true", "false" }
    end,
    desc = "Set/toggle " .. key .. " in the project's .neoconf.json",
  })
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

  create_boolean_setting_command("LocalConfigAllowProjectTsdk", "allow_project_tsdk", M.is_allow_project_tsdk)
  create_boolean_setting_command("LocalConfigPreferJJ", "prefer_jj", M.prefer_jj)
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
  local neoconf = require("neoconf")
  return neoconf.get("vscode.js/ts.experimental.useTsgo") == true
    or neoconf.get("vscode.typescript.experimental.useTsgo") == true
end

-- Settings that may point at the native TS (typescript 7 / tsgo) tsdk, in the
-- same priority order as the VS Code extension's tsdk resolution. Not every
-- candidate necessarily resolves to a native compiler (typescript.tsdk may
-- point at a ts 5 install for the non-native extension) — callers are expected
-- to try each in order and skip candidates without a native binary.
local native_tsdk_settings = {
  "vscode.js/ts.tsdk.path",
  "vscode.typescript.tsdk",
  "vscode.typescript.native-preview.tsdk",
}

function M.get_native_tsdk_candidates()
  local neoconf = require("neoconf")

  local candidates = {}
  for _, setting in ipairs(native_tsdk_settings) do
    local value = neoconf.get(setting)
    if type(value) == "string" and value ~= "" then
      candidates[#candidates + 1] = value
    end
  end

  if #candidates == 0 then
    return {}
  end

  if not M.is_allow_project_tsdk() then
    vim.notify("Project configuration contains custom tsdk but allow_project_tsdk isn't set")
    return {}
  end

  -- VS Code resolves a relative tsdk against the workspace root
  local root
  for i, path in ipairs(candidates) do
    if path:sub(1, 1) ~= "/" then
      root = root or require("neoconf.workspace").find_root({})
      candidates[i] = vim.fs.joinpath(root, path)
    end
  end

  return candidates
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
