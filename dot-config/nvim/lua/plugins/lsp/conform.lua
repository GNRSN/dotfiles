return {
  -- Handles formatting
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo", "Format", "PrettierdReload" },
    config = function()
      -- Phasing out prettierd for oxfmt which works
      -- best as an lsp-based formatter through oxc language server.
      -- (running it directly through conform didn't seem to read the config file)
      local maybe_prettier = {}

      -- LATER: This won't work in a monorepo mixing formatters between packages
      local enable_prettier = require("util.local-config").is_prettier_enabled()

      if enable_prettier then
        table.insert(maybe_prettier, "prettierd")
      end

      local stylelint_and_maybe_prettier = {
        unpack(maybe_prettier),
        "stylelint",
      }

      local opts = {
        notify_on_error = true,
        notify_no_formatters = true,
        formatters_by_ft = {
          javascript = maybe_prettier,
          typescript = maybe_prettier,
          javascriptreact = maybe_prettier,
          typescriptreact = maybe_prettier,
          ["markdown.mdx"] = maybe_prettier,
          svelte = maybe_prettier,
          -- REVIEW: Will this still run stylelint + lsp oxfmt through? Should run oxfmt first and stylelint after?
          css = stylelint_and_maybe_prettier,
          scss = stylelint_and_maybe_prettier,
          less = stylelint_and_maybe_prettier,
          html = maybe_prettier,
          json = maybe_prettier,
          jsonc = maybe_prettier,
          yaml = maybe_prettier,
          markdown = maybe_prettier,
          graphql = maybe_prettier,
          lua = { "stylua" },
          nix = { "nixfmt" },
          sh = { "shfmt" },
          conf = { "shfmt" },
          kdl = { "kdlfmt" },
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
        formatters = {},
      }

      local conform = require("conform")

      conform.setup(opts)

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

      vim.api.nvim_create_user_command("PrettierdReload", function()
        vim.system({ "prettierd", "stop" }, { text = true }, function(result)
          vim.notify("Prettier deamon stopped", vim.log.levels.INFO, { title = "PrettierdReload" })
        end)
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
