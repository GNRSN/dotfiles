return {
  -- Cursor-eqsue AI interactions from nvim
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    keys = {
      { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Ask" },
      -- NOTE: Chatting is asking without expected code-generation
      { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Chat" },
      { "<leader>aC", "<cmd>AvanteClear<cr>", desc = "Clear" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Edit" },
      { "<leader>af", "<cmd>AvanteFocus<cr>", desc = "Focus" },
      { "<leader>aR", "<cmd>AvanteRefresh<cr>", desc = "Refresh" },
      { "<leader>at", "<cmd>AvanteToggle<cr>", desc = "Toggle" },
    },
    cond = function()
      return not require("util.local-config").is_work_dir()
    end,
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
      },
    },
    opts = {
      behaviour = {
        support_paste_from_clipboard = true,
      },
      hints = {
        enabled = false,
      },
      windows = {
        input = {
          prefix = " ",
          height = 6,
        },
      },
      edit = {
        border = "single",
      },
      ask = {
        floating = true,
        start_in_insert = false,
        border = "single",
        focus_on_apply = "ours",
      },
    },
  },
}
