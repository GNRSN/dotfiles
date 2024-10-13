local function load(name)
  local Util = require("lazy.core.util")
  local function _load(module)
    Util.try(function()
      require(module)
    end, {
      msg = "Failed loading " .. module,
      on_error = function(msg)
        local modpath = require("lazy.core.cache").find(module)
        if modpath then
          Util.error(msg)
        end
      end,
    })
  end

  _load("config." .. name)
end

return {
  init = function()
    -- delay notifications till vim.notify was replaced or after 500ms
    -- lazy_notify()

    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    load("options")
  end,
  setup = function()
    load("autocmds")
    load("usercmds")
    load("keymaps")
  end,
}
