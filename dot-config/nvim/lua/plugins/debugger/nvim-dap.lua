---@param config {type?:string, args?:string[]|fun():string[]?}
local function get_args(config)
  local args = type(config.args) == "function" and (config.args() or {}) or config.args or {} --[[@as string[] | string ]]
  local args_str = type(args) == "table" and table.concat(args, " ") or args --[[@as string]]

  config = vim.deepcopy(config)
  ---@cast args string[]
  config.args = function()
    local new_args = vim.fn.expand(vim.fn.input("Run with args: ", args_str)) --[[@as string]]
    if config.type and config.type == "java" then
      ---@diagnostic disable-next-line: return-type-mismatch
      return new_args
    end
    return require("dap.utils").splitstr(new_args)
  end
  return config
end

--- Gets a path to a package in the Mason registry.
--- Prefer this to `get_package`, since the package might not always be
--- available yet and trigger errors.
---@param pkg string
---@param path? string
---@param opts? { warn?: boolean }
local function get_pkg_path(pkg, path, opts)
  pcall(require, "mason") -- make sure Mason is loaded. Will fail when generating docs
  local root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
  opts = opts or {}
  opts.warn = opts.warn == nil and true or opts.warn
  path = path or ""
  local ret = root .. "/packages/" .. pkg .. "/" .. path
  if opts.warn and not vim.uv.fs_stat(ret) and not require("lazy.core.config").headless() then
    vim.notify(
      ("Mason package path not found for **%s**:\n- `%s`\nYou may need to force update the package."):format(pkg, path),
      vim.log.levels.WARN
    )
  end
  return ret
end

-- DAP config based on LazyVim
-- LATER: Potentially tweak log level https://github.com/mfussenegger/nvim-dap/discussions/276
return {
  {
    -- LazyVim: "Debugging support. Requires language specific adapters to be configured. (see lang extras)",
    "mfussenegger/nvim-dap",

    dependencies = {
      "rcarriga/nvim-dap-ui",
      -- virtual text for the debugger
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      },

      "nvim-lua/plenary.nvim",
    },

    -- stylua: ignore
    keys = {
      { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Breakpoint" },
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>df", function() require("dap.ui.widgets").hover() end, desc = "Open float (hover)" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate" },
    },

    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- NOTE: 💀 Make sure to update this path to point to your installation
            args = {
              get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then
            config.type = "pwa-node"
          end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      -- Potentially even more indepth config
      -- https://github.com/nikolovlazar/dotfiles/blob/92c91ed035348c74e387ccd85ca19a376ea2f35e/.config/nvim/lua/plugins/dap.lua
      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            { -- Launch current file
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            { -- Attach to running node process
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
            { -- Debug in browser
              type = "pwa-chrome",
              request = "launch",
              name = "Launch & Debug Chrome",
              url = function() -- Allow picking which process
                local co = coroutine.running()
                return coroutine.create(function()
                  vim.ui.input({
                    prompt = "Enter URL: ",
                    default = "http://localhost:3000",
                  }, function(url)
                    if url == nil or url == "" then
                      return
                    else
                      coroutine.resume(co, url)
                    end
                  end)
                end)
              end,
              webRoot = vim.fn.getcwd(),
              protocol = "inspector",
              sourceMaps = true,
              userDataDir = false,
            },
            { -- Divider for the launch.json derived configs (defined by workspace)
              name = "----- ↓ launch.json configs ↓ -----",
              type = "",
              request = "launch",
            },
          }
        end
      end
    end,

    config = function()
      -- load mason-nvim-dap here, after all adapters have been setup
      require("mason-nvim-dap").setup(
        -- Obtain and reuse opts through Lazy
        require("lazy.core.plugin").values(
          require("lazy.core.config").spec.plugins["mason-nvim-dap.nvim"],
          "opts",
          false
        )
      )

      for name, sign in pairs(require("config.icons").dap) do
        vim.fn.sign_define("Dap" .. name, { text = sign[1], texthl = sign[2], linehl = sign[3], numhl = sign[3] })
      end

      -- setup dap config by VsCode launch.json file
      ---@diagnostic disable-next-line: duplicate-set-field
      require("dap.ext.vscode").json_decode = function(str)
        return vim.json.decode(require("plenary.json").json_strip_comments(str))
      end
    end,
  },

  -- fancy UI for the debugger
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "nvim-neotest/nvim-nio" },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "breakpoints",
              size = 0.25,
            },
            {
              id = "watches",
              size = 0.25,
            },
            {
              id = "scopes",
              size = 0.25,
            },
            {
              id = "stacks",
              size = 0.25,
            },
          },
          position = "right",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 0.5,
            },
            {
              id = "console",
              size = 0.5,
            },
          },
          position = "bottom",
          size = 10,
        },
      },
    },
    config = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup(opts)
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- mason.nvim integration
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = "mason.nvim",
    cmd = { "DapInstall", "DapUninstall" },
    opts = {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        "js",
      },
    },
    -- mason-nvim-dap is loaded when nvim-dap loads
    config = function() end,
  },
}
