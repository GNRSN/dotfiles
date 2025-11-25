return {
  {
    "hedyhli/outline.nvim",
    keys = {
      { "<leader>O", "<cmd>Outline<CR>", desc = "Toggle Outline" },
    },
    opts = {
      keymaps = {
        up_and_jump = "<C-p>",
        down_and_jump = "<C-n>",
      },
      outline_items = {
        show_symbol_lineno = true,
      },
    },
  },
}
