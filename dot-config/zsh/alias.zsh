alias cat=bat

alias ".."="cd .."
alias lz=lazygit
alias lg="lazygit --use-config-file \"$XDG_CONFIG_HOME/lazygit/config.yml,$XDG_CONFIG_HOME/lazygit/graphite.yml\""
alias nv=nvim
alias pn=pnpm
alias px=pnpx
alias pt="pnpm turbo"
alias l='eza -l'
alias tree='eza -T'
alias nvide="neovide --frame=transparent --title-hidden"
alias llama="ollama run llama3.1:latest"
alias yz=yazi
alias aid="aider"

# gcal with monday as first columns
alias cal='gcal --starting-day=1 "$@"' 
alias timestamp='$ZDOTDIR/bin/ms-timestamp-to-readable.sh'

# Zsh has a built in log command that may take precedence when simply calling `log`
alias apple-log='/usr/bin/log'

# https://gist.github.com/akatrevorjay/9fc061e8371529c4007689a696d33c62
git-commits() {
	local g=(
		git log
		--graph
		--format='%C(auto)%h%d %s %C(white)%C(bold)%cr'
		--color=always
		"$@"
	)

	local fzf=(
		fzf
		--ansi
		--reverse
		--tiebreak=index
		--no-sort
		--bind=ctrl-s:toggle-sort
		--preview 'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1; }; f {}'
	)
	$g | $fzf
}
