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
      { "<leader>ax", "<cmd>AvanteToggle<cr>", desc = "Close" },
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
      provider = "claude",
      claude = {
        endpoint = "https://api.anthropic.com",
        model = "claude-3-7-sonnet-20250219",
        timeout = 30000, -- Timeout in milliseconds
        temperature = 0.4,
        max_tokens = 8000,
      },
      -- claude = {
      --   endpoint = "https://api.anthropic.com",
      --   model = "claude-3-5-sonnet-20241022",
      --   temperature = 0,
      --   max_tokens = 4096,
      -- },
      system_prompt = "",
      behaviour = {
        -- Defaults to false but Im pretty sure I dont want this
        auto_suggestions = false,
        support_paste_from_clipboard = true,
        -- I think I want this?
        use_cwd_as_project_root = true,
      },
      file_selector = {
        provider = "fzf",
        -- TODO: enable preview
        provider_opts = {},
      },
      hints = {
        enabled = false,
      },
      mappings = { -- So that hints are correct
        ask = "<leader>aa", -- ask
        edit = "<leader>ae", -- edit
        refresh = "<leader>ar", -- refresh
        submit = {
          normal = "<C-s>",
          insert = "<C-s>",
        },
      },
      sidebar = {
        apply_all = "A",
        apply_cursor = "a",
        remove_file = "dd",
        add_file = "<leader><space>",
        close = { "<Esc>", "q", "<C-q>" },
        close_from_input = { normal = "<C-q>", insert = "<C-q>" },
      },
      windows = {
        sidebar_header = {
          enabled = false,
          rounded = false,
        },
        input = {
          prefix = " ",
          height = 7,
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
      -- LATER: Explore RAG
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
