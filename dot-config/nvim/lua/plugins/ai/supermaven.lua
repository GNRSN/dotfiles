return {
  {
    "supermaven-inc/supermaven-nvim",
    cond = function()
      return not require("util.local-config").is_work_dir()
    end,
    opts = {
      keymaps = {
        accept_word = "<left-arrow>",
      },
      disable_keymaps = true,
      disable_inline_completion = true,
    },
  },
}
