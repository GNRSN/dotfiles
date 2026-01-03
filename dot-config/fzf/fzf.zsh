# REVIEW: I already have a zinit plugin for fzf-tab? 
#
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

export FZF_DEFAULT_OPTS='
  --info="inline-right"
  --no-separator
  --scrollbar="█"
  --prompt=" "
  --pointer=""
  --marker=""
  --no-bold
  --tiebreak="end"
  --gutter=" "
  --bind="change:top"
'

# LATER: Colors
#
# fg = palette.white, -- Text
# ["fg+"] = palette.fg, -- Text (current line)
# hl = palette.green, -- Highlighted substrings
# ["hl+"] = palette.green, -- Highlighted substrings on current line
# ["bg+"] = palette.visual_bg, -- Current line word background
# gutter = "-1", -- Gutter, just hide it
# prompt = palette.blue_medium, -- Path
# pointer = palette.pink, -- The current line indicator
# spinner = palette.pink, -- The spinner
# info = palette.text_ignored, -- Match counter
# query = palette.yellow, -- Input query
#
# FzfLuaBorder = { fg = palette.fade },
# FzfLuaTitle = { fg = palette.white },
# FzfLuaCursor = { fg = palette.white },
# FzfLuaCursorLine = { bg = palette.visual_bg },
# FzfLuaCursorLineNumber = { fg = palette.fade },
# FzfLuaSearch = { bg = palette.green },

# LATER: I used to not use gitignore for grep but have a custom ignore list
#
# "package_lock.json",
# "pnpm-lock.yaml",
# ".git/*",
#
# rg_opts = build_ripgrep_ignore_globs(GREP_IGNORE_LIST)
#   .. "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",

# LATER: I had vim style ctrl u/d keybinds for scrolling preview
