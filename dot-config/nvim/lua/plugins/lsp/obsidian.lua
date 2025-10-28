local OBSIDIAN_FOLDER_PATTERN = vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md"

return {
  -- Support for "intellisense" in Obsidian vaults
  -- LATER: Consider:
  -- Use obsidian as previewer
  -- https://github.com/oflisback/obsidian-bridge.nvim
  -- LSP in codeblocks
  -- https://github.com/jmbuhr/otter.nvim
  -- Excalidraw
  -- https://github.com/marcocofano/excalidraw.nvim
  -- Quick add
  -- https://github.com/efirlus/quickadd.nvim
  -- Kanban
  -- https://github.com/arakkkkk/kanban.nvim
  --
  -- TODO: Create daily note from template?
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    event = {
      "BufReadPre " .. OBSIDIAN_FOLDER_PATTERN,
      "BufNewFile " .. OBSIDIAN_FOLDER_PATTERN,
    },
    cmd = {
      "Obsidian",
    },
    keys = {
      { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
      { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
      {
        "<leader>ov",
        function()
          require("obsidian.api").follow_link(nil, { open_strategy = "vsplit" })
        end,
        desc = "Open link (vsplit)",
      },
      {
        "<leader>os",
        function()
          require("obsidian.api").follow_link(nil, { open_strategy = "hsplit" })
        end,
        desc = "Open link (hsplit)",
      },
      { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Open daily note" },
      { "<leader>ow", "<cmd>Obsidian workspace<cr>", desc = "Select workspace" },
    },
    ---@module 'obsidian'
    ---@type obsidian.config
    opts = {
      legacy_commands = false,
      ui = {
        -- Does not play nicely with render-markdown.nvim which I prefer overall
        enable = false,
      },
      completion = {
        blink = true,
        nvim_cmp = false,
        min_chars = 0,
      },
      picker = {
        name = "fzf-lua",
      },
      footer = {
        enabled = true,
        format = "{{backlinks}} backlinks  {{properties}} properties",
        separator = string.rep("-", 30),
      },
      workspaces = {
        {
          name = "Personal",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Personal",
        },
        {
          name = "Work",
          path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Work",
        },
        -- LATER: It is also possible to create a custom function here for "dynamic" workspaces
        -- DOC: https://github.com/obsidian-nvim/obsidian.nvim/wiki/Workspace
      },
      callbacks = {
        enter_note = function(note)
          -- Override file picker keybind with quick switch which mixes grep and create
          vim.keymap.set(
            "n",
            "<leader><space>",
            "<cmd>Obsidian quick_switch<cr>",
            { desc = "Quick switch", buffer = note.bufnr }
          )
        end,
      },
    },
  },
}
