-- Bunch of great examples for customization https://github.com/folke/snacks.nvim/discussions/1768

return {
  { -- Bunch of utils from Folke
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    keys = {
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      { -- LATER: I'd like this to grep only in the active buffer
        "<leader>/",
        function()
          Snacks.picker.grep({ buffers = true })
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
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
      {
        "<leader>fg",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Find file with diff",
      },
      { -- LATER: I'd like to be able to grep within diffs here, e.g. for "todo" comments, but its only grepping on file names?
        "<leader>fG",
        function()
          Snacks.picker.git_diff()
        end,
        desc = "Find git diff",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.resume()
        end,
        desc = "Resume (Snacks.picker)",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep (Snacks)",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>si",
        function()
          Snacks.picker.icons()
        end,
        desc = "Icons",
      },
      {
        "<leader>sk",
        function()
          Snacks.picker.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sP",
        function()
          Snacks.picker.lazy()
        end,
        desc = "Search for Plugin Spec",
      },

      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>fs",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection",
        mode = { "x" },
      },
      {
        "<leader>uC",
        function()
          Snacks.picker.colorschemes()
        end,
        desc = "Colorschemes",
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
        ---@param buf number
        ---@param win number
        filter = function(buf, win)
          local default_cond = vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""

          -- REVIEW: Would it be nice to have it in codeblocks though?
          return default_cond and vim.bo[buf].filetype ~= "markdown"
        end,
      },

      notifier = {
        enabled = true,
        ---@type snacks.notifier.style
        style = "compact",
      },

      picker = {
        -- replace native ui.select
        ui_select = true,
        layout = {
          preset = function()
            return vim.o.columns >= 120 and "custom" or "custom_vertical"
          end,
        },
        formatters = {
          file = {
            filename_first = true,
          },
        },
        matcher = {
          frecency = true,
        },
        previewers = {
          diff = {
            -- fancy: Snacks fancy diff (borders, multi-column line numbers, syntax highlighting)
            -- syntax: Neovim's built-in diff syntax highlighting
            -- terminal: external command (git's pager for git commands, `cmd` for other diffs)
            style = "terminal", ---@type "fancy"|"syntax"|"terminal"
            cmd = { "difft" }, -- example for using `delta` as the external diff command
            ---@type vim.wo?|{} window options for the fancy diff preview window
            wo = {
              breakindent = true,
              wrap = true,
              linebreak = true,
              showbreak = "",
            },
          },
        },
        win = {
          input = {
            keys = {
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<CR>"] = { "confirm", mode = { "n", "i" } },
            },
          },
        },
        layouts = {

          custom = {
            reverse = true,
            layout = {
              box = "horizontal",
              backdrop = false,
              width = 0.92,
              height = 0.9,
              border = "none",
              {
                box = "vertical",
                border = true,
                title = "{title} {live} {flags}",
                title_pos = "center",
                { win = "list", border = "none" },
                { win = "input", height = 1, border = "top" },
              },
              {
                win = "preview",
                title = "{preview:Preview}",
                width = 0.45,
                border = true,
                title_pos = "center",
              },
            },
          },

          custom_vertical = {
            reverse = true,
            layout = {
              backdrop = false,
              width = 0.5,
              min_width = 80,
              height = 0.8,
              min_height = 30,
              box = "vertical",
              border = true,
              title = "{title} {live} {flags}",
              title_pos = "center",
              { win = "preview", title = "{title}", height = 0.4, border = "bottom" },
              { win = "list", border = "none" },
              { win = "input", height = 1, border = "top" },
            },
          },
        },
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
          Snacks.toggle
            .new({
              name = "Autosession",
              get = function()
                return require("auto-session.config").auto_save
              end,
              set = function(state)
                -- Very weird naming but this is actually a toggle
                require("auto-session").DisableAutoSave(state)
              end,
            })
            :map("<leader>us")

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
