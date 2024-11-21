-- REVIEW: Do I actually need this when using custom nvim config dir?
local root = (vim.fn.fnamemodify("~/dotfiles/.repro", ":p"):gsub("/$", ""))

-- set stdpaths to use .repro
for _, name in ipairs({ "config", "data", "state", "cache" }) do
  vim.env[("XDG_%s_HOME"):format(name:upper())] = root .. "/" .. name
end

-- bootstrap lazy
local lazypath = root .. "/plugins/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- install plugins
local plugins = {

  {
    "ibhagwan/fzf-lua",
    keys = {
      {
        "<leader><space>",
        function()
          require("fzf-lua").files({ multiprocess = true })
        end,
        desc = "Search files (fzf)",
      },
    },
  },
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

vim.g.mapleader = " "

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.cursorline = true

require("lazy").setup(plugins, {
  root = root .. "/plugins",
})
