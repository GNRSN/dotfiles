-- The tsdk setting points at the @typescript/native-preview wrapper package;
-- the actual binary lives in the sibling platform package. Mirrors the VS Code
-- extension's resolveTsdkPathToExe (see getExePath.js in the wrapper package).
local function tsdk_to_exe(tsdk)
  local direct = vim.fs.joinpath(tsdk, "tsgo")
  if vim.fn.executable(direct) == 1 then
    return direct
  end

  local uname = vim.uv.os_uname()
  local platform = ({ Darwin = "darwin", Linux = "linux", Windows_NT = "win32" })[uname.sysname]
  local arch = ({ x86_64 = "x64", arm64 = "arm64", aarch64 = "arm64" })[uname.machine]
  local exe =
    vim.fs.joinpath(vim.fs.dirname(tsdk), ("native-preview-%s-%s"):format(platform, arch), "lib", "tsgo")
  if vim.fn.executable(exe) == 1 then
    return exe
  end
end

---@type vim.lsp.Config
return {
  -- cmd must be a function: this file is sourced by vim.lsp.enable() during
  -- startup, before neoconf is set up. A function defers the neoconf lookup
  -- until the server actually spawns (FileType), when local-config is ready.
  cmd = function(dispatchers, config)
    local cmd = "tsgo"

    local tsdk = require("util.local-config").get_tsgo_tsdk_from_config()
    if tsdk then
      local exe = tsdk_to_exe(tsdk)
      if exe then
        cmd = exe
      else
        vim.notify("tsgo: no executable found for tsdk " .. tsdk .. ", falling back", vim.log.levels.WARN)
      end
    end

    if cmd == "tsgo" and (config or {}).root_dir then
      -- Mirrors the upstream nvim-lspconfig default we're overriding:
      -- prefer the workspace-local binary when present
      local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)
      if vim.fn.executable(local_cmd) == 1 then
        cmd = local_cmd
      end
    end

    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
  end,
}
