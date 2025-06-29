local M = { utils = {} }

function M.utils.refresh_git()
  -- Refresh git signs buffers
  require("gitsigns").refresh()
  -- Refresh neo-tree
  local neo_tree_events = require("neo-tree.events")
  neo_tree_events.fire_event(neo_tree_events.GIT_EVENT)
end

local win_options = {
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
    M.utils.refresh_git()
  end,
}

---@param options? { force_graphite?: boolean }
function M.utils.lazygit_smart_open(options)
  local opts = options or {}
  local project_uses_graphite = require("util.local-config").get_workspace_config().graphite

  if project_uses_graphite or opts.force_graphite then
    Snacks.terminal(
      "lazygit --use-config-file \"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/graphite.yml\"",
      {
        win = win_options,
      }
    )
  else
    Snacks.terminal("lazygit", {
      win = win_options,
    })
  end
end

return M
