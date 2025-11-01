return {
  {
    "supermaven-inc/supermaven-nvim",
    cond = function()
      return not require("util.local-config").is_work_dir()
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = {
      keymaps = {
        accept_suggestion = nil,
        accept_word = "<left-arrow>",
      },
      disable_keymaps = true,
      disable_inline_completion = true,
      ignore_filetypes = { "bigfile", "snacks_input", "snacks_notif" },
    },
  },
  -- add ai_accept action
  {
    "supermaven-inc/supermaven-nvim",
    opts = function()
      require("supermaven-nvim.completion_preview").suggestion_group = "SupermavenSuggestion"
      require("config.CMP").register_action("ai_accept", function()
        local suggestion = require("supermaven-nvim.completion_preview")
        if suggestion.has_suggestion() then
          require("config.CMP").create_undo()
          vim.schedule(function()
            suggestion.on_accept_suggestion()
          end)
          return true
        end
      end)
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "supermaven-nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "supermaven" },
        providers = {
          supermaven = {
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
