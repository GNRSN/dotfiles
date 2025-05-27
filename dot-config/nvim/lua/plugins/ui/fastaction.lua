return {
  -- Code actions ui
  {
    "Chaitanyabsprip/fastaction.nvim",
    keys = {
      {
        "<leader>ca",
        function()
          require("fastaction").code_action()
        end,
        desc = "Code actions",
        mode = { "n" },
      },
      {
        "<leader>ca",
        function()
          require("fastaction").range_code_action()
        end,
        desc = "Code actions",
        mode = { "v" },
      },
    },
    ---@type FastActionConfig
    opts = {
      popup = {
        title = false,
      },
      -- Temp fix: https://github.com/Chaitanyabsprip/fastaction.nvim/issues/40#issuecomment-2911339072
      dismiss_keys = { "<c-c>" },

    },
  },
}
