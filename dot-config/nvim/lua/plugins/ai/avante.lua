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
      -- return not require("util.local-config").is_work_dir()
      return true
    end,
    version = false,
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "ibhagwan/fzf-lua", -- for file_selector provider fzf
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
      file_selector = {
        provider = "fzf",
        -- TODO: enable preview
        provider_opts = {},
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
        border = "rounded",
      },
      ask = {
        floating = true,
        start_in_insert = true,
        border = "single",
        focus_on_apply = "ours",
      },
      rag_service = {
        enabled = false,
        host_mount = os.getenv("HOME"), -- Host mount path for the rag service
        provider = "ollama", -- The provider to use for RAG service (e.g. openai or ollama)
        llm_model = "", -- The LLM model to use for RAG service
        embed_model = "", -- The embedding model to use for RAG service
        endpoint = "https://api.openai.com/v1", -- The API endpoint for RAG service
      },
    },
  },
}
