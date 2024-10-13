local M = {}

function M.get_state()
  return vim.g.format_on_save
end

function M.enable()
  vim.g.format_on_save = true
  vim.print("Format on save enabled")
end

function M.disable()
  vim.g.format_on_save = false
  vim.print("Format on save disabled")
end

function M.toggle(value)
  if not M.get_state() then
    M.enable()
  else
    M.disable()
  end
end

function M.get_formatting_dir()
  return vim.fn.getcwd()
end

function M.write_to_config()
  -- local files = require("neoconf.commands").get_files({ global = true })
  -- local global_config = files[1]
  -- vim.print(files)
  -- if not global_config.is_global then
  --   error("did not find global config")
  -- end
  --
  -- local complete_config = vim.json.decode(vim.fn.readfile(global_config.file)[1])
  --
  -- complete_config["format_on_save"] = { ["config_per_dir"] = config_per_dir }
  --
  -- local ok, result = pcall(vim.fn.writefile, { vim.json.encode(complete_config) }, global_config.file)
  -- vim.print({
  --   ok = ok,
  --   result = result,
  -- })
end

function M.init()
  local defaults = {
    config_per_dir = {},
  }

  require("neoconf.plugins").register({
    name = "format_on_save",
    on_schema = function(schema)
      -- this call will create a json schema based on the lua types of your default settings
      schema:import("format_on_save", defaults)
      -- Optionally update some of the json schema
      schema:set("format_on_save.config_per_dir", {
        description = "Map of paths to boolean value",
        anyOf = {
          { type = "boolean" },
        },
      })
    end,
  })

  local current_dir = M.get_formatting_dir()
  local config_per_dir = require("neoconf").get("format_on_save", defaults).config_per_dir

  if type(config_per_dir[current_dir]) ~= "boolean" then
    config_per_dir[current_dir] = true
  end

  vim.g.format_on_save = config_per_dir[current_dir]
end

return M
