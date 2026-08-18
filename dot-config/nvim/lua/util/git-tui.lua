local M = { utils = {} }

function M.utils.refresh_git()
  -- Refresh git signs buffers
  -- gitsigns may be cond-disabled (prefer_jj), in which case it can't be required
  if package.loaded["gitsigns"] then
    require("gitsigns").refresh()
  end
end

local win_options = {
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
    M.utils.refresh_git()
  end,
}

function M.utils.lazygit_smart_open()
  local local_config = require("util.local-config")

  if local_config.prefer_jj() then
    Snacks.terminal("lazyjj", {
      win = win_options,
    })
    return
  end

  -- Delegate to the shared router: it aborts on non-git dirs (instead of
  -- lazygit's repo picker) and selects the graphite config when a `.gt` dir
  -- is present, keeping nvim and the shell binding in sync.
  Snacks.terminal("$XDG_CONFIG_HOME/lazygit/lazygit-router.sh", {
    win = win_options,
  })
end

return M
