return {
  { -- Bunch of utils from Folke
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- DOC: bigfile adds a new filetype bigfile to Neovim that triggers when the file is larger than the configured size.
      -- This automatically prevents things like LSP and Treesitter attaching to the buffer.
      bigfile = { enabled = true },

      -- Dashboard
      dashboard = { enabled = false },

      lazygit = {
        configure = false,
      },

      notifier = {
        enabled = false,
      },

      -- Doc: When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
      quickfile = { enabled = false },

      statuscolumn = { enabled = false },

      -- "cursor word"-esque
      words = { enabled = false },

      styles = {},
    },
    keys = {
      {
        "<leader>un",
        function()
          Snacks.notifier.hide()
        end,
        desc = "Dismiss All Notifications",
      },
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "<leader>gF",
        function()
          Snacks.lazygit.log_file()
        end,
        desc = "Lazygit Current File History",
      },
      {
        "<leader>gl",
        function()
          Snacks.lazygit.log()
        end,
        desc = "Lazygit Log (cwd)",
      },
      { -- Maybe better as usercmd? How common is this?
        -- Can also integrate with neo-tree, see docs
        "<leader>cR",
        function()
          Snacks.rename.rename_file()
        end,
        desc = "Rename File",
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          -- REVIEW: I should already have these from copying lazyvim
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.treesitter():map("<leader>uT")
          Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")

          -- Add News command
          vim.api.nvim_create_user_command("News", function()
            Snacks.win({
              file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
              width = 0.6,
              height = 0.8,
              backdrop = 0.5,
              minimal = true,
            })
          end, { desc = "Show Neovim News" })
        end,
      })
    end,
  },
}