return {
  { -- Session manager
    "rmagatti/auto-session",
    lazy = false,

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      use_git_branch = true,
      auto_restore_last_session = true,
      suppressed_dirs = { "~/", "~/github", "~/Downloads", "/", vim.env.WORK_DIR },
      -- log_level = 'debug',
    },
  },
}
