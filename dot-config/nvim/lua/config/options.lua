vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt -- for conciseness

-- NOTE: Do not set blend options in this file, e.g. neovide config updates them automatically

opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,preview"
opt.conceallevel = 2 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.mousemodel = "extend" -- Avoid right click opening annoying menu
opt.number = true -- Print line number
opt.pumheight = 11 -- Maximum number of entries in a popup
opt.relativenumber = true -- Relative line numbers
opt.ruler = false -- Hides the row+col coordinates to the bottom right
opt.scrolloff = 4 -- Lines of context
-- Auto-session.nvim recommended opts
-- REVIEW: Removed "help" since often help pages wont be loaded (due to lazy) when a session is restored, resulting in an error
opt.sessionoptions = "blank,curdir,folds,localoptions,tabpages,terminal,winpos,winsize"
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.showcmd = false -- Dont show command being written out in bottom right
opt.showmode = false -- Dont show mode since we have a statusline doing that
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
-- This and which-key messes with nvim-surround
opt.timeoutlen = 700
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
---@diagnostic disable-next-line: assign-type-mismatch
opt.wildcharm = ("<Tab>"):byte() -- Set wildcharm, see https://github.com/neovim/neovim/issues/18000 for why :byte
opt.winminwidth = 10 -- Minimum window width

-- Wrapping
opt.wrap = true
opt.linebreak = true
opt.breakindent = true

opt.splitkeep = "screen"
vim.g.incsearch = true
vim.g.hlsearch = true
-- Hide messages
opt.shortmess:append({
  I = true,
  c = true,
  C = true,
  s = true,
})
opt.fixeol = true

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
