return {
  { -- Jump to letters on screen
    "ggandor/leap.nvim",
    url = "https://codeberg.org/andyg/leap.nvim",
    -- DOC: Lazy-loads itself, using lazyspec keys may have issues
    lazy = false,
    config = function(_, opts)
      -- LATER: Here is a discussion from the author about keybinds, they recommend s/S which collides with surround/subbstitute
      -- https://github.com/ggandor/leap.nvim/discussions/59#discussioncomment-3842315
      local modes = { "n", "x", "o" }
      vim.keymap.set(modes, "z", function()
        require("leap").leap({})
      end, { desc = "Leap forward to..." })

      vim.keymap.set(modes, "Z", function()
        require("leap").leap({ backward = true })
      end, { desc = "Leap forward to..." })

      vim.keymap.set(modes, "gz", "<Plug>(leap-from-window)", { desc = "Leap from windows" })

      -- DOC: Recipe: 1-character search (enhanced f/t motions)
      --
      -- Return an argument table for `leap()`, tailored for f/t-motions.
      local function as_ft(key_specific_args)
        local common_args = {
          inputlen = 1,
          inclusive = true,
          -- To limit search scope to the current line:
          -- pattern = function (pat) return '\\%.l'..pat end,
          opts = {
            labels = "", -- force autojump
            safe_labels = vim.fn.mode(1):match("[no]") and "" or nil, -- [1]
          },
        }
        return vim.tbl_deep_extend("keep", common_args, key_specific_args)
      end

      local clever = require("leap.user").with_traversal_keys -- [2]
      local clever_f = clever("f", "F")
      local clever_t = clever("t", "T")

      for key, key_specific_args in pairs({
        f = { opts = clever_f },
        F = { backward = true, opts = clever_f },
        t = { offset = -1, opts = clever_t },
        T = { backward = true, offset = 1, opts = clever_t },
      }) do
        vim.keymap.set({ "n", "x", "o" }, key, function()
          require("leap").leap(as_ft(key_specific_args))
        end)
      end

      ------------------------------------------------------------------------
      -- [1] Match the modes here for which you don't want to use labels
      --     (`:h mode()`, `:h lua-pattern`).
      -- [2] This helper function makes it easier to set "clever-f"-like
      --     functionality (https://github.com/rhysd/clever-f.vim), returning
      --     an `opts` table derived from the defaults, where the given keys
      --     are added to `keys.next_target` and `keys.prev_target`
    end,
  },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },
}
