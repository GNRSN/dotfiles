-- The tsdk setting points at the compiler package (or its lib dir); the actual
-- native binary lives in the sibling @typescript/<base>-<platform>-<arch>
-- platform package. Mirrors the VS Code extension's resolveTsdkPathToExe (kept
-- in sync with getExePath.js in the typescript package). As of typescript 7
-- the native compiler ships in the plain `typescript` package (bin `tsc`);
-- during preview it was `@typescript/native-preview` (bin `tsgo`). Both
-- layouts are handled.

local function read_package_json(dir)
  local fd = io.open(vim.fs.joinpath(dir, "package.json"), "r")
  if not fd then
    return nil
  end
  local content = fd:read("*a")
  fd:close()

  local ok, json = pcall(vim.json.decode, content)
  if ok and type(json) == "table" then
    return json
  end
end

local function tsdk_to_exe(tsdk)
  local uname = vim.uv.os_uname()
  local platform = ({ Darwin = "darwin", Linux = "linux", Windows_NT = "win32" })[uname.sysname]
  local arch = ({ x86_64 = "x64", arm64 = "arm64", aarch64 = "arm64" })[uname.machine]

  -- tsdk may point at the package dir or its lib dir; check both. Resolve
  -- symlinks first: under pnpm the package dir is a symlink into the virtual
  -- store, and the platform package is only a sibling of the real path.
  local dirs = {}
  for _, dir in ipairs({ tsdk, vim.fs.dirname(tsdk) }) do
    dirs[#dirs + 1] = vim.uv.fs_realpath(dir) or dir
  end

  for _, dir in ipairs(dirs) do
    local pkg = read_package_json(dir)
    if pkg and type(pkg.name) == "string" and type(pkg.bin) == "table" then
      local base = pkg.name:match("^@[^/]+/(.+)") or pkg.name
      local bin_name = base == "typescript" and "tsc" or "tsgo"
      if pkg.bin[bin_name] then
        local node_modules = vim.fs.dirname(dir)
        if pkg.name:sub(1, 1) == "@" then
          node_modules = vim.fs.dirname(node_modules)
        end
        local exe =
          vim.fs.joinpath(node_modules, "@typescript", ("%s-%s-%s"):format(base, platform, arch), "lib", bin_name)
        if vim.fn.executable(exe) == 1 then
          return exe
        end
      end
    end
  end

  -- tsdk may also point straight at a dir containing the binary (e.g. a
  -- platform package's lib dir)
  for _, bin_name in ipairs({ "tsc", "tsgo" }) do
    local exe = vim.fs.joinpath(dirs[1], bin_name)
    if vim.fn.executable(exe) == 1 then
      return exe
    end
  end
end

---@type vim.lsp.Config
return {
  -- cmd must be a function: this file is sourced by vim.lsp.enable() during
  -- startup, before neoconf is set up. A function defers the neoconf lookup
  -- until the server actually spawns (FileType), when local-config is ready.
  cmd = function(dispatchers, config)
    local cmd

    local candidates = require("util.local-config").get_native_tsdk_candidates()
    for _, tsdk in ipairs(candidates) do
      local exe = tsdk_to_exe(tsdk)
      if exe then
        cmd = exe
        break
      end
    end
    if not cmd and #candidates > 0 then
      vim.notify("tsc: no executable found for configured tsdk, falling back", vim.log.levels.WARN)
    end

    if not cmd then
      -- Mirrors the upstream nvim-lspconfig default we're overriding: prefer
      -- the workspace-local binary, tsc (typescript 7) before tsgo (preview)
      for _, bin in ipairs({ "tsc", "tsgo" }) do
        if (config or {}).root_dir then
          local local_cmd = vim.fs.joinpath(config.root_dir, "node_modules/.bin", bin)
          if vim.fn.executable(local_cmd) == 1 then
            cmd = local_cmd
            break
          end
        end
        if vim.fn.executable(bin) == 1 then
          cmd = bin
          break
        end
      end
    end

    return vim.lsp.rpc.start({ cmd or "tsc", "--lsp", "--stdio" }, dispatchers)
  end,
}
