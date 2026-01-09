# === Basics ===
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Default path for stow
export STOW_DIR=$HOME/dotfiles

# === Default editor ===
export VISUAL="nvim"
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

# === Secrets ===
if command -v pass > /dev/null 2>&1; then
  # REVIEW: How do I toggle personal vs work?
  export ANTHROPIC_API_KEY=$(pass show anthropic/personal/api-key)
else
  echo "pass is not available, secrets have not been loaded into env"
fi

# === Homebrew ===

# Do not include vscode plugins in dumpfile
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=true

# === Rust ===
export RUSTUP_HOME=$XDG_DATA_HOME/rustup
export CARGO_HOME=$XDG_DATA_HOME/cargo
. "/Users/egunnarsson/.local/share/cargo/env"

# === Neovide ===

# Frame style
export NEOVIDE_FRAME="transparent"
# Detach from terminal
export NEOVIDE_FORK=1
# Macos only, no title on window
export NEOVIDE_TITLE_HIDDEN=1
# Don't open file in separate tab
export NEOVIDE_TABS=0

# === Fzf ===

source $XDG_CONFIG_HOME/fzf/fzf.zsh

# === Misc ===

# Delta git diff viewer also uses bat theme automatically
export BAT_THEME="CustomTheme"

# Load env for work
source $ZDOTDIR/work.zsh
