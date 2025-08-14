# REVIEW: .zprofile doesn't get sourced in multiplexers, should I move all of this to .zshrc?

# Load homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# config pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
