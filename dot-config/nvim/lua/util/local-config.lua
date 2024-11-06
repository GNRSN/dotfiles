local M = {}

-- List of allowed paths
-- LATER: Get this from neoconf
local whitelist = {
  -- Experiment with experience in non-work dirs before considering security implications
  ai = {
    "~/dotfiles",
  },
  graphite = {
    "~/dotfiles",
  },
}

function M.get_whitelist(key)
  return whitelist[key]
end

-- Compare current working directory against a given path
function M.is_cwd_match(path)
  return vim.fn.getcwd() == vim.fn.expand(path)
end

-- Check if current working directory is in allowed paths
--- @param key string
function M.is_allowed_path(key)
  local allowed_paths = M.get_whitelist(key)
  for _, path in ipairs(allowed_paths) do
    if M.is_cwd_match(path) then
      return true
    end
  end
  return false
end

return M
