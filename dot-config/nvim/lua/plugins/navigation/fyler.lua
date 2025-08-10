return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  keys = {
    {
      "<BS>",
      function()
        if vim.bo.filetype ~= "fyler" then
          require("fyler").open()
        end
      end,
      desc = "Open parent directory (fyler)",
    },
  },
  opts = {
    icon_provider = "nvim-web-devicons",
    views = {
      explorer = {
        width = 0.95,
        height = 0.9,
        kind = "float",
      },
    },
  },
}
