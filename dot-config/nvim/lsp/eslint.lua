---@type vim.lsp.Config
return {
  root_dir = require("util.find-root").find_git_ancestor,
  settings = {
    workingDirectory = { mode = "auto" },
    experimental = {
      useFlatConfig = true,
    },
  },
}
