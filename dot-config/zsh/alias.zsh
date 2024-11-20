alias cat=bat

alias ".."="cd .."
alias lz=lazygit
alias nv=nvim
alias pn=pnpm
alias l='eza -l'
alias tree='eza -T'
alias nvide="neovide --frame=transparent --title-hidden"
alias llama="ollama run llama3.1:latest"

# gcal with monday as first columns
alias cal='gcal --starting-day=1 "$@"' 
alias timestamp='$ZDOTDIR/bin/ms-timestamp-to-readable.sh'

# Zsh has a built in log command that may take precedence when simply calling `log`
alias apple-log='/usr/bin/log'
