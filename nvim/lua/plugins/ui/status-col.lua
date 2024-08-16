return {
  -- Status column
  {
    "luukvbaal/statuscol.nvim",
    config = function()
      local builtin = require("statuscol.builtin")
      require("statuscol").setup({
        setopt = true,
        -- Prevent cursor line number being left adjusted (default behavior with relative line numbers)
        relculright = true,
        ft_ignore = {
          "neo-tree",
          "neotest",
          "neotest-summary",
          "neotest-output-panel",
          "Trouble",
          "noice",
          "undotree",
          "spectre_panel",
          "octo",
          "DiffviewFiles",
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
      })
    end,
  },
}
