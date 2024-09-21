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
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("neotest").setup({
        adapters = {
          require("neotest-vitest"),
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
              return vim.fn.getcwd()
            end,
          }),
          -- require("neotest-python")({
          --   dap = { justMyCode = false },
          -- }),
          -- require("neotest-plenary"),
          -- require("neotest-vim-test")({
          --   ignore_file_types = { "python", "vim", "lua" },
          -- }),
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        output_panel = {
          enabled = true,
          open = "botright vsplit | vertical resize 50",
        },
        icons = {
          watching = "👀",
          running = "🏃",
          passed = "✅",
          failed = "❌",
          skipped = "",
          unknown = "",
          collapsed = "󰍟",
          expanded = "󰍝",
          child_indent = "│ ",
          child_prefix = "",
          final_child_indent = "│ ",
          final_child_prefix = "",
          non_collapsible = "",
          -- Borrowed from:
          -- https://github.com/j-hui/fidget.nvim/blob/60404ba67044c6ab01894dd5bf77bd64ea5e09aa/lua/fidget/spinner/patterns.lua#L36
          running_animated = {
            "◜",
            "◠",
            "◝",
            "◞",
            "◡",
            "◟",
          },
        },
      })
    end,
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
          require("neotest").watch.toggle(vim.fn.expand("%"))
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
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Output panel (toggle)",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Summary panel (toggle)",
      },
      {
        "<leader>tc",
        function()
          require("neotest").output_panel.clear()
        end,
        desc = "Clear output",
      },
    },
  },
}
