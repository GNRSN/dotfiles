local Terminal = require("toggleterm.terminal").Terminal

local M = { utils = {} }

function M.utils.refresh_git()
  -- Refresh git signs buffers
  require("gitsigns").refresh()
  -- Refresh neo-tree
  local neo_tree_events = require("neo-tree.events")
  neo_tree_events.fire_event(neo_tree_events.GIT_EVENT)
end

local base_config = {
  cmd = "lazygit",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "none",
  },
  -- function to run on opening the terminal
  on_open = function(term)
    vim.cmd("startinsert!")
    vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
  end,
  -- function to run on closing the terminal
  on_close = function(term)
    vim.cmd("startinsert!")
    M.utils.refresh_git()
  end,
}

M.lazygit = Terminal:new(base_config)

M.lazygit_graphite = Terminal:new(vim.tbl_extend("force", base_config, {
  cmd = "lazygit --use-config-file \"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/graphite.yml\"",
}))

function M.utils.lazygit_smart_open()
  -- LATER: Get from neoconf
  local graphite_dirs = {
    vim.env.HOME .. "/dotfiles",
  }
  local is_graphite_cwd = false

  for _, v in pairs(graphite_dirs) do
    if vim.fn.getcwd() == v then
      is_graphite_cwd = true
      break
    end
  end

  if is_graphite_cwd then
    M.lazygit_graphite:toggle()
  else
    M.lazygit:toggle()
  end
end

return M
