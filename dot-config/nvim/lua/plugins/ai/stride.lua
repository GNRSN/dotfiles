return {
  -- Next edit prediction through cerebras low latency/fast inferance LLM hosting
  {
    "jim-at-jibba/nvim-stride",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter", -- optional, smart context
      "folke/snacks.nvim", -- optional, animated notifications
    },
    cond = function()
      return not require("util.local-config").is_work_dir()
    end,
    config = function()
      require("stride").setup({
        -- Try this first, I already have supermaven completion
        mode = "refactor",

        debounce_ms = 200, -- Debounce for insert mode (ms)
        debounce_normal_ms = 300, -- Debounce for normal mode edits (ms)
        accept_keymap = "<Tab>", -- Key to accept suggestion
        dismiss_keymap = "<Esc>", -- Key to dismiss suggestion (normal mode)
      })
    end,
  },
}
