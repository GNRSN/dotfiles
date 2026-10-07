return {
  "lewis6991/gitsigns.nvim",
  cond = function()
    return not require("util.local-config").prefer_jj()
  end,
  event = { "BufReadPre", "BufNewFile" },
  keys = {
    { "<leader>gb", "<cmd>Gitsigns blame_line<CR>", { desc = "Blame Line" } },
    { "<leader>gB", "<cmd>Gitsigns blame<CR>", { desc = "Open file blame panel" } },
    {
      "gn",
      function()
        require("gitsigns").nav_hunk("next")
      end,
      { desc = "Next Hunk" },
    },
    {
      "gp",
      function()
        require("gitsigns").nav_hunk("prev")
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
