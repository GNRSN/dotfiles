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

function M.toggle()
  if not M.get_state() then
    M.enable()
  else
    M.disable()
  end
end

return M
