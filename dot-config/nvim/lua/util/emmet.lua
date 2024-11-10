local M = {}

---@param entry cmp.Entry
local function is_incomplete_emmet(entry)
  local is_emmet_source = (entry.source.source.client and entry.source.source.client.name == "emmet_language_server")
    or false

  if is_emmet_source and not entry.exact then
    return 1
  else
    return 0
  end
end

-- Custom sorter, should send completion items from emmet_language_server to the bottom
-- Should be the frist comparator to ensure all non-exact emmet suggestions are sent to the bottom
---@type cmp.ComparatorFunction
function M.emmet_comparator(entry1, entry2)
  local entry1_under = is_incomplete_emmet(entry1)
  local entry2_under = is_incomplete_emmet(entry2)
  entry1_under = entry1_under or 0
  entry2_under = entry2_under or 0
  if entry1_under > entry2_under then
    return false
  elseif entry1_under < entry2_under then
    return true
  end
end

return M
