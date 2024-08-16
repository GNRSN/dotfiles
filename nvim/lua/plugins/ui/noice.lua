local CONCEAL_CMD = false

return {
  -- Noice is multiple things, but foremost its an event/message router,
  -- it allows filtering/mapping messages to different UIs,
  -- hence an overlap/conflict with any UI plugin trying to do this in its own, e.g. nvim notify
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@type LazySpec
    dependencies = {
      -- DOC: if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",
        opts = {
          render = "wrapped-compact",
          stages = "fade",
        },
      },
    },
    keys = {
      { "<leader>sn", "<cmd>Noice telescope<cr>", desc = "Search notifications" },
    },
    config = function()
      require("noice").setup({
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          command_palette = false, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
        lsp = {
          -- DOC: override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
          signature = {
            -- LATER: Overlaps with cmp, this one has better highlighting through, but also overlaps the completion list
            enabled = false,
          },
          progress = {
            -- Attatch custom hl groups to default format
            format = {
              {
                "{progress} ",
                key = "progress.percentage",
                contents = {
                  { "{data.progress.message} " },
                },
                hl_group = "NoiceLspProgressBar",
              },
              { "({data.progress.percentage}%) " },
              { "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
              { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
              { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
            },
            format_done = {
              { "✔ ", hl_group = "NoiceLspProgressDone" },
              { "{data.progress.title} ", hl_group = "NoiceLspProgressTitle" },
              { "{data.progress.client} ", hl_group = "NoiceLspProgressClient" },
            },
          },
        },
        cmdline = {
          format = {
            cmdline = {
              title = "Command",
              pattern = "^:",
              icon = " ",
              lang = "vim",
              conceal = CONCEAL_CMD,
            },
            search_down = {
              title = "Search 󰁆",
              kind = "Search",
              pattern = "^/",
              icon = " ",
              lang = "regex",
              conceal = CONCEAL_CMD,
            },
            search_up = {
              title = "Search 󰁞",
              kind = "Search",
              pattern = "^%?",
              icon = " ",
              lang = "regex",
              conceal = CONCEAL_CMD,
            },
            filter = {
              title = "Shell",
              pattern = "^:%s*!",
              icon = " ",
              lang = "bash",
              conceal = CONCEAL_CMD,
            },
            lua = {
              pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
              icon = " ",
              lang = "lua",
              conceal = CONCEAL_CMD,
            },
            help = {
              pattern = "^:%s*he?l?p?%s+",
              icon = " ",
              conceal = CONCEAL_CMD,
            },
            input = {}, -- Used by input()
          },
        },
        views = {
          notify = {},
          -- TODO: Block lsp-messages just spamming while typing,
          mini = {
            win_options = {
              -- Transparency needs to be 0 so bg can be nil
              winblend = 0,
            },
          },
        },
        routes = {
          {
            -- Hides save messages
            -- TODO: Send to mini instead
            filter = {
              event = "msg_show",
              kind = "",
              find = "written",
            },
            opts = { skip = true },
          },
        },
      })

      -- I use this to debug ui messages
      -- These are currenlty displayed in nvim-notify, not ideal
      -- LATER: Filter and show in some other UI?
      vim.api.nvim_create_user_command("TriggerSelect", function()
        vim.ui.select({ "foo", "bar" }, {}, function()
          print("result")
        end)
      end, {})
    end,
  },
}
