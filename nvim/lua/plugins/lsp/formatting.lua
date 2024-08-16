return {
  -- Handles formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format", "PrettierdReload" },
    config = function()
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          ["markdown.mdx"] = { "prettierd" },
          svelte = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          yaml = { "prettierd" },
          markdown = { "prettierd" },
          graphql = { "prettierd" },
          lua = { "stylua" },
          python = { "isort", "black" },
        },
        format_on_save = function()
          if vim.g.format_on_save then
            return {
              lsp_fallback = true,
              async = false,
              timeout_ms = 1000,
            }
          else
            return nil
          end
        end,
        -- REVIEW: I still want prettier at work though
        formatters = {
          -- prettierd = {
          --   env = {
          --     PRETTIERD_LOCAL_PRETTIER_ONLY = true,
          --   },
          -- },
        },
      })

      -- Register :Format command
      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
          local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end
        require("conform").format({ async = true, lsp_fallback = true, range = range })
      end, { range = true })

      -- Register :PrettierdRestart to reload prettierd
      vim.api.nvim_create_user_command("PrettierdReload", function()
        vim.fn.jobstart("kill $(pidof prettierd)", {
          on_exit = function()
            vim.notify("Prettier deamon killed", vim.log.levels.INFO, { title = "PrettierdReload" })
          end,
        })
      end, {})
    end,
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            lsp_fallback = true,
            async = false,
            timeout_ms = 1000,
          })
        end,
        mode = { "n", "v" },
        desc = "Format file or range",
      },
    },
  },
}
