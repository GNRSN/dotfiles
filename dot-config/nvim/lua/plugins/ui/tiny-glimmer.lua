return {
  { -- Custom "animations" for actions
    "rachartier/tiny-glimmer.nvim",
    dependencies = {
      "gbprod/yanky.nvim",
    },
    event = "VeryLazy",
    keys = {
      { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yanky yank" },
      { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Yanky put (after)" },
      { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Yanky put (before)" },
    },
    opts = {
      transparency_color = require("colorscheme.palette").selection,
      overwrite = {
        undo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "Visual",
              max_duration = 500,
              min_duration = 500,
            },
          },
        },
        redo = {
          enabled = true,
          default_animation = {
            name = "fade",
            settings = {
              from_color = "Visual",
              max_duration = 500,
              min_duration = 500,
            },
          },
        },
        yank = {
          enabled = true,
          Yank_mapping = {
            lhs = "y",
            rhs = "<Plug>(YankyYank)",
          },
          default_animation = {
            name = "fade",
            settings = {
              from_color = "YankyYanked",
              max_duration = 500,
              min_duration = 500,
            },
          }, -- Part of word that matches
        },
        paste = {
          enabled = true,
          paste_mapping = {
            lhs = "p",
            rhs = "<Plug>(YankyPutAfter)",
          },
          Paste_mapping = {
            lhs = "P",
            rhs = "<Plug>(YankyPutBefore)",
          },
          default_animation = {
            name = "fade",
            settings = {
              from_color = "YankyPut",
              max_duration = 500,
              min_duration = 500,
            },
          },
        },
      },
    },
  },
}
