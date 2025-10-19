return {
  "A7Lavinraj/fyler.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  branch = "stable",
  cond = false,
  keys = {
    {
      "<BS>",
      function()
        if vim.bo.filetype ~= "fyler" then
          require("fyler").open()
        else
          -- TODO: Should go to parent node if wanting to mimic oil?
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
