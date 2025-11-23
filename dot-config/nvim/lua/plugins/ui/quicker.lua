return {
  { -- Beter quickfix window, allows inline edit
    "stevearc/quicker.nvim",
    ft = "qf",
    keys = {
      {
        "<leader>q",
        function()
          require("quicker").toggle()
        end,
        desc = "Quickfix (Toggle)",
      },
      {
        "<leader>l",
        function()
          require("quicker").toggle({ loclist = true })
        end,
        desc = "Loclist (Toggle)",
      },
    },
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {
      keys = {
        {
          "H",
          function()
            require("quicker").expand({ before = 2, after = 2, add_to_existing = true })
          end,
          desc = "Expand quickfix context",
        },
        {
          "L",
          function()
            require("quicker").collapse()
          end,
          desc = "Collapse quickfix context",
        },
      },
    },
  },
}
