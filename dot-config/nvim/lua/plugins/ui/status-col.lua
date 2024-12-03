local BLACKLIST_FT = {
  "aerial",
  "Avante",
  "AvanteInput",
  "DiffviewFiles",
  "neo-tree",
  "neotest",
  "neotest-output-panel",
  "neotest-summary",
  "netrw",
  "noice",
  "octo",
  "oil",
  "spectre_panel",
  "Trouble",
  "trouble",
  "undotree",
}

return {
  -- Status column
  {
    "luukvbaal/statuscol.nvim",
    -- Should not be lazy loaded
    -- see: https://github.com/luukvbaal/statuscol.nvim/issues/63
    lazy = false,
    opts = function()
      local builtin = require("statuscol.builtin")
      return {
        setopt = true,
        -- Prevent cursor line number being left adjusted (default behavior with relative line numbers)
        relculright = true,
        ft_ignore = BLACKLIST_FT,
        bt_ignore = {
          "help",
        },
        segments = {
          {
            sign = {
              name = {
                "DiagnosticSignError",
                "DiagnosticSignWarn",
                "DiagnosticSignInfo",
                -- REVIEW: I've found that diagnostic signs are not prioritized in diagnostic level, leading to hints occasionally covering errors
                -- hiding hints is a workaround for now

                -- "DiagnosticSignHint",
              },
              condition = { true },
              maxwidth = 1,
              auto = false,
              fillchar = " ",
            },
            click = "v:lua.ScSa",
          },
          {
            -- line number
            text = { builtin.lnumfunc, " " },
            condition = { true, builtin.not_empty },
            click = "v:lua.ScLa",
          },
          {
            -- REVIEW: Do not know what this does, folds?
            text = { "%C" },
            click = "v:lua.ScFa",
          },
          {
            -- git sign + diagnostic
            -- text = { "%s" },
            sign = {
              namespace = { "gitsign*" },
              condition = { true },
              auto = false,
            },
            click = "v:lua.ScSa",
          },
        },
      }
    end,
  },
}
