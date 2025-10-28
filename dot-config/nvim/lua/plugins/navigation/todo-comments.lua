local palette = require("colorscheme.palette")

return {
  -- todo comments as "bookmarks" + jump between them through trouble
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      keywords = {
        REVIEW = { icon = " ", color = "review" },
        PERF = { icon = " ", color = "perf" },
        NOTE = { icon = " ", color = "note", alt = { "INFO" } },
        TODO = { icon = "  ", color = "todo" },
        LATER = { icon = "  ", color = "todo" },
        DOC = { icon = "  ", color = "doc" },
        REFACTOR = { icon = " ", color = "perf" },
        HACK = { icon = " ", color = "perf" },
      },
      merge_keywords = false,
      colors = {
        review = { palette.white },
        perf = { palette.purple },
        note = { palette.comment },
        todo = { palette.yellow_sunflower },
        doc = { palette.blue },
      },
    },
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>Trouble todo filter = {tag = {TODO}}<cr>", desc = "Todo(s) (Trouble)" },
      { "<leader>xl", "<cmd>Trouble todo filter = {tag = {LATER}}<cr>", desc = "Todo later(s) (Trouble)" },
      -- REVIEW: Can we replace with fzf or snacks picker?
      { "<leader>fct", "<cmd>TodoTelescope keywords=TODO<cr>", desc = "Todo" },
      { "<leader>fcl", "<cmd>TodoTelescope keywords=LATER<cr>", desc = "Later" },
    },
  },
}
