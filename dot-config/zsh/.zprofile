
# Load homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load env for work
source $ZDOTDIR/work.zsh

# Load fast-node-manager
# Config:
# - change version on cd
# - check parent dir for node version if not in current
# - check package.json engines field
eval "$(fnm env --use-on-cd --version-file-strategy=recursive --resolve-engines --shell zsh)"

# config pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
