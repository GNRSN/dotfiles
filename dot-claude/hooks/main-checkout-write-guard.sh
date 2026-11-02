#!/bin/bash
# main-checkout-write-guard.sh — Claude Code PreToolUse(Edit|Write) hook.
#
# Belt-and-suspenders companion to worktree-cd-guard.sh: when the session is
# inside a git *linked worktree*, deny Edit/Write whose target file lives in the
# MAIN checkout — i.e. under the main worktree but NOT inside the current
# worktree. The "not inside the current worktree" clause matters because some
# worktrees are nested under main (e.g. ~/Yolean/checkit/.claude/worktrees/<name>),
# and those files are legitimate edits.
#
# Leaves alone: edits to the worktree itself, /tmp, the scratchpad, ~/.claude, etc.
#
# Fail-open: not a git repo / in the main checkout / unresolvable path / missing
# tools -> allow. The only outcome that blocks is a file confidently resolved
# into the main checkout from a worktree session.
set -f

payload=$(cat)
file=$(printf '%s' "$payload" | jq -r '.tool_input.file_path // empty' 2>/dev/null) || exit 0
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
[ -n "$file" ] || exit 0
[ -n "$cwd" ] || exit 0

agent=$(printf '%s' "$payload" | jq -r '.agent_id // empty' 2>/dev/null)
# session root, see worktree-cd-guard.sh
if [ -n "$agent" ]; then home=$cwd; else home=${CLAUDE_PROJECT_DIR:-$cwd}; fi
cwd_p=$(cd "$cwd" 2>/dev/null && pwd -P) || cwd_p=$cwd
top=$(git -C "$home" rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -n "$top" ] || exit 0
main=$(git -C "$home" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p' | head -n1)
[ -n "$main" ] || exit 0
[ "$top" = "$main" ] && exit 0   # in the main checkout, not a worktree -> allow

normalize() {
  local p="$1" seg out="" IFS=/
  for seg in $p; do
    case "$seg" in
      ''|.) ;;
      ..)   out=${out%/*} ;;
      *)    out="$out/$seg" ;;
    esac
  done
  printf '%s' "${out:-/}"
}
under() {
  [ "$2" = "$1" ] && return 0
  case "$2" in "$1"/*) return 0 ;; esac
  return 1
}

case "$file" in
  /*) abs=$file ;;
  *)  abs=$cwd_p/$file ;;
esac
norm=$(normalize "$abs")

# Deny only when the target is in the main checkout but outside this worktree.
if under "$main" "$norm" && ! under "$top" "$norm"; then
  jq -n --arg r "main-checkout-write-guard: you're in worktree '$top' but this Edit/Write targets the MAIN checkout '$main' ('$norm'). Edit the copy inside your worktree instead (under '$top')." \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
fi
exit 0
