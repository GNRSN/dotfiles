return {
  "A7Lavinraj/fyler.nvim",
  -- dependencies = { "nvim-tree/nvim-web-devicons" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  branch = "stable",
  -- DOC: Necessary for `default_explorer` to work properly
  lazy = false,
  keys = {
    {
      "<D-BS>",
      function()
        if vim.bo.filetype ~= "fyler" then
          require("fyler").open({ kind = "float" })
        else
          -- TODO: Should go to parent node if wanting to mimic oil?
        end
      end,
      desc = "Open parent directory (fyler)",
    },
  },
  opts = {
    integrations = {
      icon = "nvim_web_devicons",
    },
    views = {
      -- finder = {
      --   width = 0.95,
      --   height = 0.9,
      --   kind = "float",
      -- },
    },
  },
}
