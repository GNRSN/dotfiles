return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame Line" } },
    { "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Blame File" } },
    {
      "gn",
      function()
        require("gitsigns").next_hunk()
      end,
      { desc = "Next Hunk" },
    },
    {
      "gp",
      function()
        require("gitsigns").prev_hunk()
      end,
      { desc = "Prev Hunk" },
    },
  },
  opts = {
    -- From old conf
    signs = {
      add = { text = "▎" },
      change = { text = "▎" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "▎" },
      untracked = { text = "▎" },
    },
    attach_to_untracked = true,
  },
}
