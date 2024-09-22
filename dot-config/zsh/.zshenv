# === Basics ===
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export ZDOTDIR=$XDG_CONFIG_HOME/zsh

# Default path for stow
export STOW_DIR=$HOME/dotfiles

# === Default editor ===
export VISUAL="neovim"
export EDITOR="$VISUAL"
export GIT_EDITOR="$VISUAL"

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

