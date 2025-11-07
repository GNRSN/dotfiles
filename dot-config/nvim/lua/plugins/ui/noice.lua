local CONCEAL_CMD = false

return {
  -- Noice is multiple things, but foremost its an event/message router,
  -- it allows filtering/mapping messages to different UIs,
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    ---@type LazySpec
    dependencies = {
      -- DOC: if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>sn", "<cmd>Noice snacks<cr>", desc = "Search notifications" },
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
        -- messages = {
        --   enabled = true,
        --   view = "mini",
        -- },
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
          mini = {
            win_options = {
              -- Transparency needs to be 0 so bg can be nil
              winblend = 0,
            },
          },
        },
        routes = {
          { -- Reroute long messages to splits
            filter = {
              event = "notify",
              min_height = 16,
            },
            view = "split",
          },
          { -- Skip: Some new message displayed by Octo
            filter = {
              event = "msg_show",
              find = "OctoEditable",
            },
          },
          -- Glance: no lsp references
          { filter = { event = "notify", find = "No definitions found" } },
          -- Hide bunch of noisy messages, copied from https://github.com/folke/noice.nvim/discussions/908#discussioncomment-10583586
          { filter = { event = "msg_show", find = "written" } },
          { filter = { event = "msg_show", find = "yanked" } },
          { filter = { event = "msg_show", find = "%d+L, %d+B" } },
          { filter = { event = "msg_show", find = "; after #%d+" } },
          { filter = { event = "msg_show", find = "; before #%d+" } },
          { filter = { event = "msg_show", find = "%d fewer lines" } },
          { filter = { event = "msg_show", find = "%d more lines" } },
          { filter = { event = "msg_show", find = "<ed" } },
          { filter = { event = "msg_show", find = ">ed" } },
        },
      })
    end,
  },
}
