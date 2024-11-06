return {
  {
    "supermaven-inc/supermaven-nvim",
    cond = function()
      return require("util.local-config").is_allowed_path("ai")
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
