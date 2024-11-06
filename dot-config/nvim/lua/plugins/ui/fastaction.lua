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
    opts = {},
  },
}
