return {
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = {
      use_diagnostic_signs = true,
      modes = {
        buffer_diagnostics = {
          mode = "diagnostics",
          filter = {
            buf = 0,
            severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
          },
        },
        workspace_diagnostics = {
          mode = "diagnostics",
          filter = {
            severity = { vim.diagnostic.severity.WARN, vim.diagnostic.severity.ERROR },
          },
        },
      },
    },
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble buffer_diagnostics toggle focus=true<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble workspace_diagnostics toggle focus=true<cr>",
        desc = "Workspace Diagnostics (Trouble)",
      },
      {
        "<leader>xs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
      {
        "<leader>xn",
        function()
          require("trouble").next({ skip_groups = true, jump = true })
        end,
        desc = "Next trouble/quickfix item",
      },
      {
        "<leader>xp",
        function()
          require("trouble").previous({ skip_groups = true, jump = true })
        end,
        desc = "Previous trouble/quickfix item",
      },

      -- {
      --   "[q",
      --   function()
      --     if require("trouble").is_open() then
      --       require("trouble").previous({ skip_groups = true, jump = true })
      --     else
      --       vim.cmd.cprev()
      --     end
      --   end,
      --   desc = "Previous trouble/quickfix item",
      -- },
      -- {
      --   "]q",
      --   function()
      --     if require("trouble").is_open() then
      --       require("trouble").next({ skip_groups = true, jump = true })
      --     else
      --       vim.cmd.cnext()
      --     end
      --   end,
      --   desc = "Next trouble/quickfix item",
      -- },
    },
  },
}
