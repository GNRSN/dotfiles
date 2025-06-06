return {
  -- Nvim integration with test runner
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      -- Adapters
      "marilari88/neotest-vitest",
      "adrigzr/neotest-mocha",
    },
    keys = {
      {
        "<leader>tr",
        function()
          require("neotest").run.run()
        end,
        desc = "Run nearest test",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "Watch nearest position",
      },
      {
        "<leader>tW",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Watch file",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run current file",
      },
      {
        "<leader>td",
        function()
          ---@diagnostic disable-next-line: missing-fields
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Run nearest test (DAP)",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop current test",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach to nearest test",
      },
      {
        "<leader>tt",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Terminal/output panel (toggle)",
      },
      {
        "<leader>to",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Summary/outline panel (toggle)",
      },
      {
        "<leader>tc",
        function()
          require("neotest").output_panel.clear()
        end,
        desc = "Clear output",
      },
    },
    opts = function()
      return {
        adapters = {
          require("neotest-vitest")({
            cwd = function(path)
              return require("util.find-root").find_node_modules_ancestor(path)
            end,
          }),
          -- Default config
          require("neotest-mocha")({
            command = "npm test --",
            command_args = function(context)
              -- The context contains:
              --   results_path: The file that json results are written to
              --   test_name_pattern: The generated pattern for the test
              --   path: The path to the test file
              --
              -- It should return a string array of arguments
              --
              -- Not specifying 'command_args' will use the defaults below
              return {
                "--full-trace",
                "--reporter=json",
                "--reporter-options=output=" .. context.results_path,
                "--grep=" .. context.test_name_pattern,
                context.path,
              }
            end,
            env = { CI = true },
            cwd = function(path)
              return require("util.find-root").find_node_modules_ancestor(path)
            end,
          }),
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        ---@diagnostic disable-next-line: missing-fields
        summary = {
          follow = true,
        },
        output_panel = {
          enabled = true,
          open = "botright vsplit | vertical resize 50",
        },
        icons = {
          watching = "👀",
          running = "▶️",
          passed = "✅",
          failed = "❌",
          skipped = "⏸️",
          unknown = "",
          collapsed = "",
          expanded = "󰍝",
          child_indent = "│ ",
          child_prefix = "",
          final_child_indent = "│ ",
          final_child_prefix = "",
          non_collapsible = "",
          -- Spinner
          running_animated = {
            "⠋",
            "⠙",
            "⠹",
            "⠸",
            "⠼",
            "⠴",
            "⠦",
            "⠧",
            "⠇",
            "⠏",
          },
        },
      }
    end,
  },
}
