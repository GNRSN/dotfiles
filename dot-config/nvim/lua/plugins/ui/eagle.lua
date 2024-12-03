return {
  -- vscode style combined hover and diagnostics window
  {
    "soulis-1256/eagle.nvim",
    cmd = { "EagleWin" },
    keys = {
      { "K", "<cmd>EagleWin<cr>", desc = "Show hover window", mode = "n" },
    },
    opts = {
      keyboard_mode = true,
      mouse_mode = false,
      border_color = require("colorscheme.palette").border,
      order = 2,
    },
  },
}
