local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

-- Copied from TJ

local shortcut = function(val)
  if type(val) == "string" then
    return { t({ val }), i(0) }
  end

  if type(val) == "table" then
    for k, v in ipairs(val) do
      if type(v) == "string" then
        val[k] = t({ v })
      end
    end
  end

  return val
end

local M = {}

M.same = function(index)
  return f(function(args)
    return args[1]
  end, { index })
end

M.make = function(tbl)
  local result = {}
  for key, val in pairs(tbl) do
    table.insert(result, (s({ trig = key, desc = val.desc }, shortcut(val))))
  end

  return result
end

M.register_snippets = function()
  for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom_snippets/ft/*.lua", true)) do
    -- Pattern match filename inc extension + strip extension
    -- which should be filetype
    local ft = ft_path:match("[^/]+$"):match("[^.]+")
    ls.add_snippets(ft, M.make(loadfile(ft_path)()))
  end
end

return M
