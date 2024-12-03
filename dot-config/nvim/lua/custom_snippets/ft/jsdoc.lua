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

-- LATER: I'm actually not very happy about these being in jsdoc ft type,
-- jsdoc ft should be inside jsdocstrings?
-- Instead I should find some way to specify js for both javascript and javascriptreact
return {
  ["/type"] = fmt([[/** @type {{{}}} */]], { i(1) }),
  ["/satisfies"] = fmt([[/** @satisfies {{{}}} */]], { i(1) }),
  ["/typedef"] = fmt([[/** @typedef {{{}}} {} */]], { i(1), i(2, "typename") }),
  ["/param"] = fmt(
    [[
  /**
   * @param {{{}}} {}
   */
     ]],
    { i(1), i(2) }
  ),
  ["/props"] = fmt(
    [[
  /**
   * @param {{object}} props
   * @param {{{}}} props.
   */
     ]],
    { i(1) }
  ),
  ["/tscheck"] = fmt(
    [[
  // @ts-check

  {}
     ]],
    { i(1) }
  ),
  ["/tsexpecterror"] = fmt(
    [[
  // @ts-expect-error{}
     ]],
    { i(1) }
  ),
  ["/import"] = fmt(
    [[
  /**
   * @import {{{}}} from '{}'
   */
     ]],
    { i(1), i(2) }
  ),
}
