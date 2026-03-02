---@type vim.lsp.Config
return {
  root_dir = function(bufnr, on_dir)
    require("util.find-root").find_git_ancestor(vim.api.nvim_buf_get_name(bufnr))
  end,
  settings = {
    -- REVIEW: Should pick up settings from .vscode/settings.json
    workingDirectory = { mode = "auto" },
  },
}
