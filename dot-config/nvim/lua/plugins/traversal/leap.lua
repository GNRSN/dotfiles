return {
  -- NOTE: Copied from LazyVim

  -- easily jump to any location and enhanced f/t motions for Leap
  {
    "ggandor/flit.nvim",
    enabled = true,
    lazy = false,
    keys = function()
      ---@type LazyKeysSpec[]
      local ret = {}
      for _, key in ipairs({ "f", "F", "t", "T" }) do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    enabled = true,
    lazy = false,
    -- REVIEW: Maybe I don't even need mappings for leap, just for flit?
    -- Here is a discussion from the author about keybinds
    -- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
    keys = {
      { "z", "<Plug>(leap-forward)", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "Z", "<Plug>(leap-backward)", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gz", "<Plug>(leap-from-window)", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      -- REVIEW: Not sure if this acutually does anything
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      -- leap.add_default_mappings(true)
      -- vim.keymap.del({ "x", "o" }, "x")
      -- vim.keymap.del({ "x", "o" }, "X")
    end,
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
