# NOTE: Should generally contain modifications only relevant for the interactive shell
# @see https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

#   ---------------------
### options
#   ---------------------

# Enable Vi mode
set -o vi
# Enable detailed prompts
setopt promptsubst

#   ---------------------
### zinit Package manager
#   ---------------------

## Define zinit folder
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

## Create folder if not already existing
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

## Source zinit
source "${ZINIT_HOME}/zinit.zsh"

## Autostart a new zellij shell, if not already inside one
if [ "$TERM_PROGRAM" = "ghostty" ] && [ "$ZELLIJ" != "0" ]; then
  eval "zellij attach -c Dotfiles"
fi

## Autostart a new tmux session, if not already inside one
# if [ "$TERM_PROGRAM" = "ghostty" ] && [ "$TMUX" != "0" ]; then
#   eval "tmux new-session -A -s dotfiles -c $HOME/dotfiles"
# fi

#   ------
### Prompt
#   ------
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config '~/.config/oh-my-posh/config.toml')"
fi

# re-export shell-variables as env-variables so OMP can access them
# DOC: https://ohmyposh.dev/docs/configuration/templates#environment-variables
function set_poshcontext() {
  if [[ $ZVM_MODE ]]; then
    export VIM_MODE=$ZVM_MODE

    # # I could not get a prompt segment to not escape escape-sequences (ironic, right?)
    # # but we can leverage that this func will/needs to run every time we change ZVM_MODE 
    if [ $ZVM_MODE = $ZVM_MODE_INSERT ]; then
      # Set blinking bar cursor
      printf "\033[5 q"
    elif [ $ZVM_MODE = $ZVM_MODE_REPLACE ]; then
      # Set blinking underline cursor
      printf "\033[3 q"
    else
      # Set default cursor (should be blinking block unless overridden in terminal emulator)
      printf "\033[0 q"
    fi
  fi
}

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a3a075"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

# DOC: fzf-tab needs to be loaded after compinit,
# but before plugins which will wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting

# function zvm_after_init() {
#   echo 'zvm after init'
#   # DOC: Load fzf after zvm to prevent overwriting keybinds
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }
# zvm_after_init_commands+=(my_init)

# This doesn't seem to work with wezterm
ZVM_CURSOR_STYLE_ENABLED=false
ZVM_VI_HIGHLIGHT_BACKGROUND=#743563           

function zvm_config() {
  # Retrieve default cursor styles
  local icur=$(zvm_cursor_style $ZVM_INSERT_MODE_CURSOR)

  # Append your custom color for your cursor
  ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;#FF79C6\a'


  ZVM_VI_HIGHLIGHT_BACKGROUND=#743563           
}

function refresh_omp() {
  if typeset -f _omp_precmd > /dev/null; then
    _omp_precmd
  fi
}

zvm_after_init_commands+=(refresh_omp)

# REVIEW: Do I want atuin through zinit or separate install?

# If autin is installed, enable it.
# if command -v atuin &> /dev/null; then
#     # Note: Since zsh-vi-mode lazy-loads keybinds, it will overwrite
#     # Some of the keybinds set by atuin. The following creates a 'callback'
#     # that loads atuin after zsh-vi-mode has applied all keymaps.
#     function atuin_init() {
#         eval "$(atuin init zsh --disable-up-arrow)"
#     }
#     zvm_after_init_commands+=(atuin_init)
# fi

# line 1: `atuin` binary as command, from github release, only look at .tar.gz files, use the `atuin` file from the extracted archive
# line 2: setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice wait lucid as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh" 
zinit load atuinsh/atuin

# The plugin will auto execute this zvm_after_select_vi_mode function
function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
      # Something you want to do...
    ;;
    $ZVM_MODE_INSERT)
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL)
      # Something you want to do...
    ;;
    $ZVM_MODE_VISUAL_LINE)
      # Something you want to do...
    ;;
    $ZVM_MODE_REPLACE)
      # Something you want to do...
    ;;
  esac

  refresh_omp
}

zinit load zdharma-continuum/fast-syntax-highlighting
# NOTE: Without loading fast-syntax-highlighting before zvm the vi mode var -> omp on mode change breaks
# I assume fast-syntax-highlighting calls something in zsh during load that we would need to call ourselves?
# REVIEW: Ideally fast-syntax-highlighting should be called after
zinit load jeffreytse/zsh-vi-mode

zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit load Aloxaf/fzf-tab

zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit load zsh-users/zsh-autosuggestions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit snippet OMZP::colored-man-pages

# Nix completions, unsure if works?
# TODO: Compare to manual install
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit load nix-community/nix-zsh-completions

# Install brew completion
# DOC: This must be done before compinit is called.
if type brew &>/dev/null
then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

  # autoload -Uz compinit
  # compinit
fi

# Nvim config switcher
zinit load mehalter/zsh-nvim-appname

# zinit gui
# DOC: https://github.com/zdharma-continuum/zinit-crasis
zinit load zdharma-continuum/zui
zinit load zdharma-continuum/zinit-crasis

# zsh linter
# See:  https://github.com/psprint/zsh-sweep
# usage: zsweep --auto [filename].zsh
zinit param'zs_set_path' for @psprint/zsh-sweep


# Zsh-autosuggestions settings
# # bindkey '^i' autosuggest-accept
# bindkey '^p' history-search-forward
# bindkey '^n' history-search-backward
# # bindkey '^ ' menu-complete

# TODO: Does this effect atuin?
HISTSIZE=100000
HISTFILE=$ZDOTDIR/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Make completion case insensitive
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# preview directory's content with eza when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'

### Load aliases
source "$ZDOTDIR/alias.zsh"

# Load zoxide and replace cd
# NOTE: Should be called at end of config
# DOC: ...must be added after compinit is called
eval "$(zoxide init zsh --cmd cd)"

# Load carapace automatic shell completion
export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
source <(carapace _carapace)
