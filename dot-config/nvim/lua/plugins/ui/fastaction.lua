local ecma = {
  { pattern = "import", key = "i", order = 1 },
  { pattern = "eslint", key = "f", order = 1 },
}

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
      priority = {
        javascript = ecma,
        javascriptreact = ecma,
        typescript = ecma,
        typescriptreact = ecma,
      },
    },
  },
}
