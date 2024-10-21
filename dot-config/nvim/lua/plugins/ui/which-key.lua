return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    local wk = require("which-key")
    wk.setup({
      triggers = {
        -- Default option, auto trigger
        { "<auto>", mode = "nxso" },
      },
      win = {
        -- border = "shadow",
        wo = {
          winblend = vim.o.winblend,
        },
      },
    })

    wk.add({
      { "g", group = "Go to ..." },
      { "]", group = "Next ..." },
      { "[", group = "Prev ..." },
      { "gp", group = "Preview" },
      { "<leader>", group = "Leader" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Debugger" },
      { "<leader>f", group = "File/find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>o", group = "Obsidian" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Testing" },
      { "<leader>T", group = "Tabs" },
      { "<leader>u", group = "Ui" },
      { "<leader>w", group = "Windows" },
      { "<leader>x", group = "Diagnostics/quickfix/todos" },
    })
  end,
}
