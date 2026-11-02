#!/bin/bash
# worktree-cd-guard.sh — Claude Code PreToolUse(Bash) hook.
#
# Purpose: keep a session in the checkout it was started in. A session started
# inside a git *linked worktree* can't `cd`/`pushd` out of it (prevents
# "accidentally edited the main checkout from a worktree session"); a session
# started in the main checkout can't `cd` into a linked worktree (it operates on
# it from outside instead).
#
# "Started in" is $CLAUDE_PROJECT_DIR, not the payload's cwd: the Bash tool's cwd
# persists across calls, so keying on cwd turned a stray `cd` into the worktree
# into a trap the guard then refused to let the session leave. Sub-agents
# (payload has agent_id) share the parent's $CLAUDE_PROJECT_DIR, so their home is
# the checkout their cwd is in: an `isolation: "worktree"` sub-agent is held in its
# worktree; one inheriting the parent's cwd is held like the parent.
#
# Layout-agnostic: it asks git for the current worktree root and the main
# checkout rather than parsing paths, so it works at any nesting depth
# (e.g. ~/Yolean/checkit/.claude/worktrees/<name> and
# ~/.t3/worktrees/checkit/<name>).
#
# Fail-open by design: any uncertainty (not a git repo, unparseable/variable
# target, missing tools) -> allow the command. The only outcome that blocks is a
# confidently-resolved cd target outside the session's checkout.
#
# MODE:
#   strict   -> block any cd/pushd whose target is outside the worktree root.
#   targeted -> block only cd/pushd whose target is inside the main checkout
#               (lets /tmp, the scratchpad, sibling worktrees, etc. through).
MODE=strict

set -f   # no filename globbing; we only pattern-match via case/${} expansion

# --- read & extract -------------------------------------------------------
payload=$(cat)
cmd=$(printf '%s' "$payload" | jq -r '.tool_input.command // empty' 2>/dev/null) || exit 0
cwd=$(printf '%s' "$payload" | jq -r '.cwd // empty' 2>/dev/null) || exit 0
agent=$(printf '%s' "$payload" | jq -r '.agent_id // empty' 2>/dev/null)
[ -n "$cmd" ] || exit 0
[ -n "$cwd" ] || exit 0

# --- fast path: bail unless a cd/pushd word is present --------------------
printf '%s' "$cmd" | grep -qE '(^|[^[:alnum:]_])(cd|pushd)([[:space:]]|$)' || exit 0

# --- locate session root + main checkout via git --------------------------
if [ -n "$agent" ]; then home=$cwd; else home=${CLAUDE_PROJECT_DIR:-$cwd}; fi
cwd_p=$(cd "$cwd" 2>/dev/null && pwd -P) || cwd_p=$cwd   # physical, matches git output
top=$(git -C "$home" rev-parse --show-toplevel 2>/dev/null) || exit 0
[ -n "$top" ] || exit 0
worktrees=$(git -C "$home" worktree list --porcelain 2>/dev/null | sed -n 's/^worktree //p')
main=$(printf '%s\n' "$worktrees" | head -n1)
[ -n "$main" ] || exit 0

# --- helpers --------------------------------------------------------------
# Lexically collapse . and .. in an absolute path (no filesystem access).
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
# under BASE PATH -> success when PATH == BASE or PATH is below BASE/
under() {
  [ "$2" = "$1" ] && return 0
  case "$2" in "$1"/*) return 0 ;; esac
  return 1
}
deny() {
  jq -n --arg r "$1" \
    '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# --- inspect each statement for a leading cd/pushd ------------------------
# awk splits on ; & | ( ) { } (so chained/subshelled cds are seen). awk's
# gsub replacement "\n" is a real newline on both BSD and GNU awk.
while IFS= read -r line; do
  line=${line#"${line%%[![:space:]]*}"}        # left-trim
  word=${line%%[[:space:]]*}
  [ "$word" = cd ] || [ "$word" = pushd ] || continue

  args=${line#"$word"}
  args=${args#"${args%%[![:space:]]*}"}        # left-trim args
  target=${args%%[[:space:]]*}                 # first token

  case "$target" in                            # strip one layer of quotes
    \"*\") target=${target#\"}; target=${target%\"} ;;
    \'*\') target=${target#\'}; target=${target%\'} ;;
  esac
  case "$target" in
    -*)          continue ;;                   # option flag, not a path
    *'$'*|*'`'*) continue ;;                    # unresolved expansion -> fail-open
  esac

  case "$target" in
    "")     abs=$HOME ;;                        # bare `cd` -> home
    /*)     abs=$target ;;
    "~")    abs=$HOME ;;
    "~/"*)  abs=$HOME/${target#\~/} ;;
    *)      abs=$cwd_p/$target ;;              # relative to current dir
  esac
  norm=$(normalize "$abs")

  if [ "$top" = "$main" ]; then
    while IFS= read -r wt; do
      [ -n "$wt" ] && under "$wt" "$norm" && deny "worktree-cd-guard: this session belongs to the main checkout '$main'. \`cd $target\` enters linked worktree '$wt'. Operate on it from here instead: \`git -C '$wt' …\`, \`make -C\`/\`pnpm -C\`/\`npm --prefix\`, and absolute paths for Read/Edit. For work that needs its cwd there, ask the user to start a separate session in that worktree."
    done < <(printf '%s\n' "$worktrees" | tail -n +2)
  elif [ "$MODE" = targeted ]; then
    under "$main" "$norm" && ! under "$top" "$norm" && deny "worktree-cd-guard: you're in worktree '$top'. \`cd $target\` enters the main checkout '$main' (resolves to '$norm'). Don't operate on main from a worktree — cd back to '$top'."
  else
    under "$top" "$norm" || deny "worktree-cd-guard: you're in worktree '$top'. \`cd $target\` would leave it (resolves to '$norm'). Stay in this worktree — cd to '$top' or a path under it. (Set MODE=targeted in ~/.claude/hooks/worktree-cd-guard.sh to allow non-main excursions.)"
  fi
done < <(printf '%s\n' "$cmd" | awk '{gsub(/[;&|(){}]/,"\n"); print}')

exit 0
