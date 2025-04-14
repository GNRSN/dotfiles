local add_cmd = function(name, command, opts)
  vim.api.nvim_create_user_command(name, command, opts or {})
end

-- Scandi keyboard layout compensation

-- Because : requires pressing shift on nordic keyboard layout
add_cmd("Wa", function()
  vim.cmd.wa()
end)

add_cmd("W", function()
  vim.cmd.W()
end)

add_cmd("Qa", function()
  vim.cmd.qa()
end)

add_cmd("Q", function()
  vim.cmd.q()
end)

-- Reload

-- Suggested in https://www.reddit.com/r/neovim/comments/16e0l4o/how_to_hot_reload_highlightsscm_in_nvimtreesitter/
add_cmd("TSReload", function()
  local bufnr = vim.api.nvim_get_current_buf()
  require("vim.treesitter.highlighter").active[bufnr]:destroy()
end)

-- Refresh/reload
add_cmd("R", function()
  -- Delete all buffers but current
  local bufs = vim.api.nvim_list_bufs()
  local current_buf = vim.api.nvim_get_current_buf()
  for _, i in ipairs(bufs) do
    if i ~= current_buf then
      vim.api.nvim_buf_delete(i, {})
    end
  end

  vim.diagnostic.reset()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(":LspRestart<CR>", true, true, true), "m", false)
  vim.cmd.e()
end)

-- REVIEW: I don't understand why but adding this during conform setup didn't work?
add_cmd("PrettierdReload", function()
  os.execute("prettierd stop")
end)

add_cmd("CopyBufferPath", function()
  local buffer_path = vim.api.nvim_buf_get_name(0)

  vim.print("Copied path: " .. buffer_path)
  vim.fn.setreg("+", buffer_path)
end)
