# NOTE: Should generally contain modifications only relevant for the interactive shell
# @see https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

#   ---------------------
### enable vi mode 
#   ---------------------
set -o vi

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
  else
    # export VIM_MODE="i"
  fi
}

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#a3a075"
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"

# DOC: fzf-tab needs to be loaded after compinit,
# but before plugins which will wrap widgets, such as zsh-autosuggestions or fast-syntax-highlighting

ZVM_VI_HIGHLIGHT_FOREGROUND=#008800           # Hex value
ZVM_VI_HIGHLIGHT_BACKGROUND=#ff0000           # Hex value
ZVM_VI_HIGHLIGHT_EXTRASTYLE=bold,underline    # bold and underline

# function zvm_after_init() {
#   echo 'zvm after init'
#   # DOC: Load fzf after zvm to prevent overwriting keybinds
#   [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }
# zvm_after_init_commands+=(my_init)
#
# This doesn't seem to work with wezterm
ZVM_CURSOR_STYLE_ENABLED=false

function zvm_config() {
  # Retrieve default cursor styles
  local icur=$(zvm_cursor_style $ZVM_INSERT_MODE_CURSOR)

  # Append your custom color for your cursor
  ZVM_NORMAL_MODE_CURSOR=$ncur'\e\e]12;#FF79C6\a'
}

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

  local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
  zle reset-prompt
}
zvm_after_select_vi_mode_commands+=(zvm_after_select_vi_mode)


# REVIEW: loading zvm like this broke atuin, enter/tab just wouldn't insert anything
# I likely need to understand zinit better
#
# zinit ice depth=1
# zinit light jeffreytse/zsh-vi-mode

# line 1: `atuin` binary as command, from github release, only look at .tar.gz files, use the `atuin` file from the extracted archive
# line 2: setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" bpick"atuin-*.tar.gz" mv"atuin*/atuin -> atuin" \
    atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" \
    atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin

zinit wait lucid light-mode for \
  atinit"zicompinit; zicdreplay" \
      Aloxaf/fzf-tab \
      zdharma-continuum/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
      jeffreytse/zsh-vi-mode \
      atuinsh/atuin \
      OMZP::colored-man-pages \
  # as"completion" \
  #       OMZP::docker/_docker


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


