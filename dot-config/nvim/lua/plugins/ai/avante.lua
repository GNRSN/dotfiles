return {
  -- Cursor-eqsue AI interactions from nvim
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    -- DOC: Example settings for keys settings in lazy.nvim
    -- NOTE: If I tried to set normally with lazy.keys, avante still overwrote e.g. <leader>aa
    keys = function(_, keys)
      ---@type avante.Config
      local opts =
        require("lazy.core.plugin").values(require("lazy.core.config").spec.plugins["avante.nvim"], "opts", false)

      local mappings = {
        {
          opts.mappings.ask,
          function()
            if not require("avante").is_sidebar_open() then
              require("avante").open_sidebar({ ask = true })
            else
              require("avante").close_sidebar()
            end
          end,
          desc = "avante: Open / Close",
          mode = { "n", "v" },
        },
        {
          "<leader>aR",
          function()
            require("avante.api").refresh()
          end,
          desc = "avante: Refresh",
          mode = "v",
        },
        {
          opts.mappings.edit,
          function()
            require("avante.api").edit()
          end,
          desc = "avante: Edit",
          mode = { "n", "v" },
        },

        { "<leader>ax", "<cmd>AvanteStop<cr>", desc = "Avante Stop" },
        { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante Refresh" },
      }
      mappings = vim.tbl_filter(function(m)
        return m[1] and #m[1] > 0
      end, mappings)
      return vim.list_extend(mappings, keys)
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
      -- system_prompt = "",
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
        refresh = "<leader>aR", -- refresh
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
      selection = {
        hint_display = "none",
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
