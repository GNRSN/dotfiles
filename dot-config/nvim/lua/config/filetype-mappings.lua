-- Map filetypes to patterns
return {
  [".gitignore"] = { ".prettierignore" },
  -- LATER: jsonc ft is being overwritten, probably by  jsonls lsp? Seems to be inconsequential though and resolves with :e
  ["jsonc"] = { "turbo.json" },
}
