local M = {}

function M.stringify_table(tbl)
  local result = "{"
  for k, v in pairs(tbl) do
    -- Check the key type (ignore any numerical keys - assume its an array)
    if type(k) == "string" then
      result = result .. "[\"" .. k .. "\"]" .. "="
    end

    -- Check the value type
    if type(v) == "table" then
      result = result .. M.stringify_table(v)
    elseif type(v) == "boolean" then
      result = result .. tostring(v)
    elseif type(v) == "function" then
      result = result .. "[function]"
    else
      result = result .. "\"" .. v .. "\""
    end
    result = result .. ","
  end
  -- Remove leading commas from the result
  if result ~= "{" then
    result = result:sub(1, result:len() - 1)
  end
  return result .. "}"
end

return M
