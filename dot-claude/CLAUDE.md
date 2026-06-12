Claude code specific:

Harness restriction: a file must be Read before it can be Written or Edited. When creating a brand-new file, Write directly; for any existing file, Read it first even if you think you know its contents.

If you are in a cwd containing the path /worktrees/, ensure that you stick to that cwd and don't accidentally start modifying the main checkout.

Tooling:

I have ripgrep `rg` available if you want to use it for faster grep

`yq` and `jq` are also available for yaml and json parsing
