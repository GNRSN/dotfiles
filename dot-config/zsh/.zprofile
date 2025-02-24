
# Load homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load env for work
source $ZDOTDIR/work.zsh

# config pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
