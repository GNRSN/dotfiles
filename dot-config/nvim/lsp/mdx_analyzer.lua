local function get_typescript_server_path(root_dir)
  local project_root = require("util.find-root").find_node_modules_ancestor(root_dir)
  -- REVIEW: Unsure if this already ends with a trailing slash or not?
  vim.notify(project_root)
  return project_root and project_root .. "/node_modules/typescript/lib" or ""
end

---@type vim.lsp.Config
return {
  init_options = {
    typescript = {},
  },
  on_new_config = function(new_config, new_root_dir)
    if vim.tbl_get(new_config.init_options, "typescript") and not new_config.init_options.typescript.tsdk then
      new_config.init_options.typescript.tsdk = require("util.local-config").get_tsdk_from_config()
        or get_typescript_server_path(new_root_dir)
    end
  end,
}
