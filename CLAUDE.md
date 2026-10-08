# dotfiles

## Git workflow: Graphite

This repo uses Graphite stacked PRs. Use `gt create -m "<msg>"` instead of `git commit` and `gt modify` to amend the current branch, and only when asked to commit. Downstack branches may also be amended (`gt checkout <branch>`, then `gt modify`) as long as they have not been pushed yet. Never push or submit; the user does that.

Graphite's MCP server (`gt mcp`) is deliberately not configured: it only wraps the same `gt` binary plus a tutorial tool, with no access to PR or review data, so the CLI through Bash is equivalent.
