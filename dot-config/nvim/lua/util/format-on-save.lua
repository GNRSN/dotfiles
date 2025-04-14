local M = {}

-- Set with Snacks.toggle
function M.get_state()
  return vim.g.format_on_save
end

return M
