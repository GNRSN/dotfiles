return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    {
      -- Listens to neo-tree rename event and auto-magically performs lsp file rename
      "antosha417/nvim-lsp-file-operations",
      dependencies = {
        "nvim-lua/plenary.nvim",
        -- DOC: Please note that the order that the plugins load in is important,
        -- neo-tree must load before nvim-lsp-file-operations for it to work,
        -- so nvim-lsp-file-operations depends on neo-tree and not the other way around.
        "nvim-neo-tree/neo-tree.nvim",
      },
      config = true,
    },
    -- Adds $schema support to .json
    "b0o/schemastore.nvim",

    -- Neoconf populates configs for us so needs to load first
    "folke/neoconf.nvim",
  },
  config = function(_, opts)
    local lspconfig = require("lspconfig")

    local keymap = vim.keymap -- for conciseness
    local opts = { noremap = true, silent = true }

    local on_attach = function(_, bufnr)
      opts.buffer = bufnr

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

      keymap.set("n", "gR", "<cmd>Glance references<CR>", { desc = "Show LSP references" })

      keymap.set("n", "gd", "<Cmd>Glance definitions<CR>", { desc = "go to definition" })

      keymap.set("n", "gi", "<cmd>Glance implementations<CR>", { desc = "Show LSP implementations" })

      keymap.set("n", "gt", "<cmd>Glance type_definitions<CR>", { desc = "Show LSP type definitions" })

      opts.desc = "Lsp rename"
      keymap.set("n", "<leader>cr", vim.lsp.buf.rename, opts)

      -- LATER: These overlap with trouble? Maybe I prefer these though
      opts.desc = "Go to previous diagnostic"
      keymap.set("n", "[d", function()
        vim.diagnostic.jump({
          diagnostic = vim.diagnostic.get_prev({ severity = { min = vim.diagnostic.severity.WARN } }),
        })
      end, opts)

      opts.desc = "Go to next diagnostic"
      keymap.set("n", "]d", function()
        vim.diagnostic.jump({
          diagnostic = vim.diagnostic.get_next({ severity = { min = vim.diagnostic.severity.WARN } }),
        })
      end, opts)
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    local has_blink, blink = pcall(require, "blink.cmp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {},
      -- TODO: Is this still required in nvim 11.0?
      has_blink and blink.get_lsp_capabilities() or {},
      opts.capabilities or {}
    )

    lspconfig["html"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure css server
    lspconfig["cssls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        -- We'll use prettier for formatting instead
        provideFormatter = false,
      },
    })

    lspconfig["css_variables"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["cssmodules_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    local util = require("lspconfig.util")

    lspconfig["eslint"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = require("util.find-root").find_git_ancestor,
      settings = {
        workingDirectory = { mode = "auto" },
        experimental = {
          useFlatConfig = true,
        },
      },
    })

    local function get_typescript_server_path(root_dir)
      local project_root = require("util.find-root").find_node_modules_ancestor(root_dir)
      -- REVIEW: Unsure if this already ends with a trailing slash or not?
      vim.notify(project_root)
      return project_root and project_root .. "/node_modules/typescript/lib" or ""
    end

    lspconfig["mdx_analyzer"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      init_options = {
        typescript = {},
      },
      on_new_config = function(new_config, new_root_dir)
        if vim.tbl_get(new_config.init_options, "typescript") and not new_config.init_options.typescript.tsdk then
          new_config.init_options.typescript.tsdk = require("util.local-config").get_tsdk_from_config()
            or get_typescript_server_path(new_root_dir)
        end
      end,
    })

    lspconfig["tailwindcss"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["svelte"].setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        on_attach(client, bufnr)

        vim.api.nvim_create_autocmd("BufWritePost", {
          pattern = { "*.js", "*.ts" },
          callback = function(ctx)
            if client.name == "svelte" then
              client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
            end
          end,
        })
      end,
    })

    -- configure prisma orm server
    lspconfig["prismals"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure graphql language server
    lspconfig["graphql"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
    })

    -- LATER: See if https://github.com/olrtg/nvim-emmet is interesting
    lspconfig["emmet_language_server"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- LATER: There are some additional config options available here:
    -- https://www.reddit.com/r/neovim/comments/17h74vs/a_working_stylelintlsp_config_with_lspconfig/
    lspconfig["stylelint_lsp"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["pyright"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["lua_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- configure json server
    lspconfig["jsonls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- configure json server
    lspconfig["yamlls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        yaml = {
          schemaStore = {
            -- You must disable built-in schemaStore support if you want to use
            -- this plugin and its advanced options like `ignore`.
            enable = false,
            -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
            url = "",
          },
          schemas = require("schemastore").yaml.schemas(),
        },
      },
    })
    -- Nix language server
    -- LATER: Consider trying nixd instead
    lspconfig["nil_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    -- Treesitter query language
    lspconfig["ts_query_ls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["bashls"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lspconfig["marksman"].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })
  end,
}
