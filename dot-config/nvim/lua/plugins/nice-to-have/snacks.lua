return {
  { -- Bunch of utils from Folke
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
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
      -- LATER: Could replace fzf but needs to style/fix colors
      --
      -- {
      --   "<leader>fg",
      --   function()
      --     Snacks.picker.git_status()
      --   end,
      --   desc = "Find file with diff",
      -- },
      { -- LATER: I'd like to be able to grep within diffs here, e.g. for "todo" comments
        "<leader>fG",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Find git diff",
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
      {
        "<leader>e",
        function()
          Snacks.picker.explorer({
            layout = { preset = "vertical", preview = true },
          })
        end,
        desc = "Floating Explorer",
      },
      {
        "<leader>fd",
        function()
          Snacks.picker.diagnostics_buffer({
            severity = { min = vim.diagnostic.severity.WARN },
          })
        end,
        desc = "Diagnostics (Buffer)",
      },
      {
        "<leader>fD",
        function()
          Snacks.picker.diagnostics({
            severity = { min = vim.diagnostic.severity.WARN },
          })
        end,
        desc = "Diagnostics (Workspace)",
      },
    },
    ---@type snacks.Config
    opts = {
      -- DOC: bigfile adds a new filetype bigfile to Neovim that triggers when the file is larger than the configured size.
      -- This automatically prevents things like LSP and Treesitter attaching to the buffer.
      bigfile = { enabled = true },

      -- Dashboard
      dashboard = {
        enabled = true,
        sections = {
          { section = "header" },
          { section = "startup", gap = 1, padding = 1 },
        },
      },

      ---@diagnostic disable-next-line: missing-fields
      lazygit = {
        configure = false,
      },

      indent = {
        enabled = true,
        animate = {
          enabled = false,
        },
      },

      notifier = {
        enabled = true,
        ---@type snacks.notifier.style
        style = "compact",
      },

      picker = {
        ui_select = true,
      },

      -- DOC: When doing nvim somefile.txt, it will render the file as quickly as possible, before loading your plugins.
      quickfile = { enabled = false },

      -- DOC: Smooth scrolling for Neovim. Properly handles scrolloff and mouse scrolling.
      scroll = {
        enabled = true,
        animate = {
          duration = { step = 10, total = 150 },
          easing = "outQuad",
        },
      },

      statuscolumn = { enabled = false },

      toggle = {
        color = {
          enabled = "green",
          disabled = "white",
        },
      },

      -- "cursor word"-esque
      ---@diagnostic disable-next-line: missing-fields
      words = { enabled = false },

      styles = {},
    },
    config = function(_, opts)
      local notify = vim.notify
      require("snacks").setup(opts)
      -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
      -- this is needed to have early notifications show up in noice history
      -- THX Folke <3
      -- @see https://github.com/folke/snacks.nvim/discussions/225
      vim.notify = notify
    end,
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
          -- LATER: Toggle format on save
          --
          -- LATER: This breaks spellunker and apparently options are persisted between sessions
          -- Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          Snacks.toggle.diagnostics():map("<leader>ud")
          -- Snacks.toggle.line_number():map("<leader>ul")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle
            .new({
              name = "Format on save",
              get = function()
                return vim.g.format_on_save
              end,
              set = function(state)
                vim.g.format_on_save = state
              end,
            })
            :map("<leader>uf")

          -- Add lsp rename callback for Oil
          vim.api.nvim_create_autocmd("User", {
            pattern = "OilActionsPost",
            callback = function(event)
              if event.data.actions.type == "move" then
                Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
              end
            end,
          })

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
