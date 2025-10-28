return {
  { -- Alternating colors for brackets

    -- LATER: See if its possible to inject typescript into jsdoc comments to get colored brackets inside,
    -- example from render-markdown for injecting markdown into gitcommit filetype
    --
    -- gitcommit = {
    --     enabled = true,
    --     query = [[
    --         ((message) @injection.content
    --             (#set! injection.combined)
    --             (#set! injection.include-children)
    --             (#set! injection.language "markdown"))
    --     ]],
    -- },
    "HiPhish/rainbow-delimiters.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- This module contains a number of default definitions
      local rainbow_delimiters = require("rainbow-delimiters")

      -- This is how they recommend configuring the plugin,
      -- docs say .setup should would work too but I get an error with it
      vim.g.rainbow_delimiters = {
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          -- Default behavior is rainbow tags for jsx
          javascript = "rainbow-parens",
          typescript = "rainbow-parens",
          tsx = "rainbow-parens",
        },
        highlight = {
          -- This order mimics vs-code
          "RainbowDelimiterYellow",
          "RainbowDelimiterViolet",
          "RainbowDelimiterBlue",
        },
      }
    end,
  },
}
