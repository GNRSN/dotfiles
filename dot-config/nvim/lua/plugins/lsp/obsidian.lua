return {
  -- Support for "intellisense" in Obsidian vaults
  -- LATER: Consider https://github.com/oflisback/obsidian-bridge.nvim
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
      -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
      -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
      -- refer to `:h file-pattern` for more examples
      "BufReadPre "
        .. vim.fn.expand("~")
        .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md",
      "BufNewFile " .. vim.fn.expand("~") .. "/Library/Mobile Documents/iCloud~md~obsidian/Documents/**/*.md",
      -- TODO: Load if cwd matches obsidian vault
    },
    keys = {
      { "<leader>on", "<cmd>ObsidianNew<cr>", desc = "New note" },
      { "<leader>os", "<cmd>ObsidianFollowLink vsplit<cr>", desc = "Open (vsplit)" },
      { "<leader>oS", "<cmd>ObsidianFollowLink hsplit<cr>", desc = "Open (hsplit)" },
      { "<leader>ob", "<cmd>ObsidianBacklinks<cr>", desc = "Backlinks" },
      { "<leader>ot", "<cmd>ObsidianToday<cr>", desc = "Open daily note" },
      { "<leader>op", "<cmd>ObsidianWorkspace Personal<cr>", desc = "Workspace: Personal" },
      { "<leader>ow", "<cmd>ObsidianWorkspace Work<cr>", desc = "Workspace: Work" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = {
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
      },
    },
  },
}
