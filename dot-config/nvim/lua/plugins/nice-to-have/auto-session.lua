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
      suppressed_dirs = {
        "/",
        "/Users",
        "~/",
        "~/github",
        "~/Downloads",
      },
      -- log_level = "debug",
    },
  },
}
