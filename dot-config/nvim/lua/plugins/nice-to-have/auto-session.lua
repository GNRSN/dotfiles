return {
  { -- Session manager
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      auto_save = true,
      auto_restore = true,
      use_git_branch = true,
      -- This automatically restores the last session, regardless of cwd
      auto_restore_last_session = false,
      -- Filtering
      suppressed_dirs = {
        "/",
        "/Users",
        "~/",
        "~/github",
        "~/Downloads",
      },
      -- List of filetypes to bypass auto save when the only buffer open is one of the file types listed, useful to ignore dashboards
      bypass_save_filetypes = {
        "snacks_dashboard",
      },
      -- Buffers with matching filetypes will be closed before saving
      close_filetypes_on_save = {
        "checkhealth",
        "help", -- Would like to keep this but it crashes for plugins which are lazy-loaded
        "neotest-summary",
        "neotest-output-panel",
      },
    },
  },
}
