#!/usr/bin/env bash
# Claude Code status line, styled after the nvim lualine setup in dot-config/nvim.
#
#   NORMAL       dotfiles /  main                              ✳ Opus 5
#   ^^^^^^       ^^^^^^^^^^^^^^^^^^^                           ^^^^^^^^
#   section a    section b                                     section z
#   (left)       (starts at the middle, flows right)           (right)
#
# Only the branch name is ever truncated; the model name always renders in full.
#
# Colours mirror dot-config/nvim/lua/colorscheme/palette.lua and the section
# mapping in dot-config/nvim/lua/colorscheme/status-line.lua. They are copied
# rather than generated, so update both places if the palette changes.
#
# Docs: https://code.claude.com/docs/en/statusline

# --- palette ----------------------------------------------------------------
P_BG="#1E1E1E"
P_BLACK="#0e0e0e"
P_WHITE="#ABB2BF"
P_FG="#f0f0eb"
P_BLUE="#569CD6"
P_GREEN="#50fa7b"
P_ORANGE="#FFB86C"
P_SUNFLOWER="#FFEA00"
P_FADE="#555555"

# ansi <varname> <fg-hex> [bg-hex] [bold]
ansi() {
  local __var=$1 f=${2#\#} b=${3:-} bold=${4:-}
  local seq=''
  [[ -n $bold ]] && seq+=$'\033[1m'
  printf -v seq '%s\033[38;2;%d;%d;%dm' "$seq" "0x${f:0:2}" "0x${f:2:2}" "0x${f:4:2}"
  if [[ -n $b ]]; then
    b=${b#\#}
    printf -v seq '%s\033[48;2;%d;%d;%dm' "$seq" "0x${b:0:2}" "0x${b:2:2}" "0x${b:4:2}"
  fi
  printf -v "$__var" '%s' "$seq"
}
RESET=$'\033[0m'

# Width maths below counts characters, which needs a UTF-8 ctype; Claude Code
# does not guarantee one in the spawned environment.
[[ -z ${LC_ALL:-}${LC_CTYPE:-}${LANG:-} ]] && export LC_CTYPE=UTF-8

# --- input ------------------------------------------------------------------
input=$(cat)

# Unit separator, so empty fields survive `read` (tabs would be collapsed).
IFS=$'\037' read -r VIM_MODE MODEL CUR_DIR PROJ_DIR REPO_NAME GIT_WT WT_NAME WT_BRANCH <<<"$(
  jq -r '[
    (.vim.mode // ""),
    (.model.display_name // ""),
    (.workspace.current_dir // .cwd // ""),
    (.workspace.project_dir // ""),
    (.workspace.repo.name // ""),
    (.workspace.git_worktree // ""),
    (.worktree.name // ""),
    (.worktree.branch // "")
  ] | join("\u001f")' <<<"$input" 2>/dev/null
)"

DIR=${CUR_DIR:-${PROJ_DIR:-$PWD}}

# The context window size is a property of the session, not something worth a
# permanent slot, so drop a trailing "(1M context)" style suffix.
MODEL=${MODEL% (*context)}

# --- vim mode (lualine section a) -------------------------------------------
case $VIM_MODE in
  NORMAL) MODE_LABEL="NORMAL"; ACCENT=$P_WHITE; MODE_FG=$P_BG ;;
  INSERT) MODE_LABEL="INSERT"; ACCENT=$P_BLUE; MODE_FG=$P_BLACK ;;
  VISUAL) MODE_LABEL="VISUAL"; ACCENT=$P_GREEN; MODE_FG=$P_BLACK ;;
  "VISUAL LINE") MODE_LABEL="V-LINE"; ACCENT=$P_GREEN; MODE_FG=$P_BLACK ;;
  "VISUAL BLOCK") MODE_LABEL="V-BLOCK"; ACCENT=$P_GREEN; MODE_FG=$P_BLACK ;;
  REPLACE) MODE_LABEL="REPLACE"; ACCENT=$P_ORANGE; MODE_FG=$P_BLACK ;;
  "") MODE_LABEL=""; ACCENT=$P_WHITE; MODE_FG=$P_BG ;;
  *) MODE_LABEL=${VIM_MODE^^}; ACCENT=$P_SUNFLOWER; MODE_FG=$P_BLACK ;;
esac

if [[ -n $MODE_LABEL ]]; then
  LEFT_PLAIN=" $MODE_LABEL "
  ansi _mode "$MODE_FG" "$ACCENT" bold
  LEFT_COLOR="${_mode}${LEFT_PLAIN}${RESET}"
else
  LEFT_PLAIN=""
  LEFT_COLOR=""
fi

# NOTE: no permission-mode segment here on purpose. Claude Code renders its own
# "⏵⏵ auto mode on" badge in the footer row below this one, and nothing can turn
# it off: the statusLine schema only has type/command/padding/refreshInterval/
# hideVimModeIndicator, and the badge's visibility depends solely on session
# kind. Mirroring it here just duplicates it.

# --- repo / worktree / branch (lualine section b) ---------------------------
# Walk upward for a marker directory without shelling out.
find_up() {
  local marker=$1 d=$2
  while [[ -n $d && $d != / ]]; do
    [[ -e $d/$marker ]] && { printf '%s' "$d"; return 0; }
    d=${d%/*}
  done
  [[ -e /$marker ]] && { printf '/'; return 0; }
  return 1
}

BRANCH=""
BRANCH_MARK=""
ROOT=""

# A jj checkout always leaves git HEAD detached, so an attached git branch means
# the repo is being driven by git even when it is colocated with a .jj dir.
GIT_BRANCH=${WT_BRANCH:-$(git -C "$DIR" symbolic-ref --quiet --short HEAD 2>/dev/null)}
# `jj git init` leaves HEAD attached to this placeholder until the first jj edit.
[[ $GIT_BRANCH == jj/root ]] && GIT_BRANCH=""

if [[ -n $GIT_BRANCH ]]; then
  BRANCH_MARK=""
  BRANCH=$GIT_BRANCH
  ROOT=$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null)
elif JJ_ROOT=$(find_up .jj "$DIR"); then
  ROOT=$JJ_ROOT
  BRANCH_MARK="@"
  # Nearest bookmark at or below @, with a "+" when @ has moved past it.
  # --ignore-working-copy keeps the status line from snapshotting / taking
  # repo locks on every redraw.
  BRANCH=$(jj --ignore-working-copy --no-pager log --no-graph -R "$JJ_ROOT" \
    -r 'heads(::@ & bookmarks())' \
    -T 'bookmarks.join(",") ++ if(current_working_copy, "", "+") ++ "\n"' 2>/dev/null | head -1)
  # No bookmark anywhere in @'s ancestry: fall back to the change id.
  [[ -z $BRANCH ]] && BRANCH=$(jj --ignore-working-copy --no-pager log --no-graph \
    -R "$JJ_ROOT" -r @ -T 'change_id.shortest(8)' 2>/dev/null)
elif ROOT=$(git -C "$DIR" rev-parse --show-toplevel 2>/dev/null); then
  # Git repo with a detached HEAD and no jj.
  BRANCH_MARK=""
  BRANCH=$(git -C "$DIR" rev-parse --short HEAD 2>/dev/null)
fi

REPO=${REPO_NAME:-}
[[ -z $REPO && -n $ROOT ]] && REPO=${ROOT##*/}
[[ -z $REPO ]] && REPO=${DIR##*/}

# `--worktree` sessions report worktree.name; any other linked git worktree
# shows up as workspace.git_worktree.
WORKTREE=${WT_NAME:-$GIT_WT}

ansi C_FADE "$P_FADE"
ansi C_FG "$P_FG"
ansi C_WHITE "$P_WHITE"

build_mid() {
  MID_PLAIN=""
  MID_COLOR=""
  # Tight path-style separator: every column spent here is a column the branch
  # name does not get.
  local sep_p="/" sep_c="${C_FADE}/${RESET}"

  if [[ -n $REPO ]]; then
    MID_PLAIN+=$REPO
    MID_COLOR+="${C_FG}${REPO}${RESET}"
  fi
  if [[ -n $WORKTREE ]]; then
    [[ -n $MID_PLAIN ]] && { MID_PLAIN+=$sep_p; MID_COLOR+=$sep_c; }
    MID_PLAIN+=$WORKTREE
    MID_COLOR+="${C_WHITE}${WORKTREE}${RESET}"
  fi
  if [[ -n $BRANCH ]]; then
    [[ -n $MID_PLAIN ]] && { MID_PLAIN+=$sep_p; MID_COLOR+=$sep_c; }
    # BRANCH_MARK is "@" in a jj repo and empty for git, butted straight against
    # the name so it costs one column rather than two.
    MID_PLAIN+="$BRANCH_MARK$BRANCH"
    MID_COLOR+="${C_FADE}${BRANCH_MARK}${RESET}${C_WHITE}${BRANCH}${RESET}"
  fi
}
build_mid

# --- model (lualine section z) ----------------------------------------------
# Bare name, no icon: the model is unmistakable without one, and the two columns
# an icon costs are better spent on the branch.
if [[ -n $MODEL ]]; then
  RIGHT_PLAIN="$MODEL"
  RIGHT_COLOR="${C_WHITE}${MODEL}${RESET}"
else
  RIGHT_PLAIN=""
  RIGHT_COLOR=""
fi

# --- layout -----------------------------------------------------------------
# Claude Code exports COLUMNS; `tput cols` cannot see the terminal from here.
COLS=${COLUMNS:-80}
(( COLS < 20 )) && COLS=20
# Claude Code indents the status line row inside its own frame, so the render
# area is narrower than COLUMNS. Overshooting means Claude clips the tail of the
# line (the model) with its own "…", so reserve the frame's gutters here.
MARGIN=4
USABLE=$((COLS - MARGIN))
GAP=2  # breathing room before the model
LEAD=1 # after the mode block, which already carries its own trailing space

left_w=${#LEFT_PLAIN}
right_w=${#RIGHT_PLAIN}

# The model name is never shortened. If it cannot even share the line with the
# mode block, the mode block is what gives way.
if (( left_w + GAP + right_w > USABLE )); then
  LEFT_PLAIN=""; LEFT_COLOR=""; left_w=0
fi

# The middle segment sits directly after the mode block, so it always starts at
# the same column instead of leaving a void that grows with the terminal width.
# Slack collects on the right, ahead of the model.
pad=$LEAD

overflow() { echo $((left_w + pad + ${#MID_PLAIN} + GAP + right_w - USABLE)); }

# 1. truncate the branch name — the only segment allowed to lose characters
over=$(overflow)
if (( over > 0 && ${#BRANCH} > 0 )); then
  keep=$((${#BRANCH} - over - 1))
  if (( keep >= 3 )); then BRANCH="${BRANCH:0:keep}…"; else BRANCH=""; fi
  build_mid
fi

# 2. drop the worktree, then the middle segment as a whole
if (( $(overflow) > 0 )) && [[ -n $WORKTREE ]]; then
  WORKTREE=""
  build_mid
fi
if (( $(overflow) > 0 )); then
  MID_PLAIN=""; MID_COLOR=""
fi
[[ -z $MID_PLAIN ]] && pad=0

# When the model is alone on the line it gets no leading padding at all, so a
# terminal only just wide enough for it still renders it without wrapping.
min_gap=1
[[ -z $LEFT_PLAIN && -z $MID_PLAIN ]] && min_gap=0

gap_right=$((USABLE - left_w - pad - ${#MID_PLAIN} - right_w))
(( gap_right < min_gap )) && gap_right=$min_gap

printf '%s%*s%s%*s%s\n' \
  "$LEFT_COLOR" "$pad" '' "$MID_COLOR" "$gap_right" '' "$RIGHT_COLOR"
