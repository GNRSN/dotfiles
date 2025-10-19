return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
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

      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Glance references<CR>", opts)

      opts.desc = "go to definition"
      keymap.set("n", "gd", "<Cmd>Glance definitions<CR>", opts)

      opts.desc = "Show LSP implementations"
      keymap.set("n", "gi", "<cmd>Glance implementations<CR>", opts)

      opts.desc = "Show LSP type definitions"
      keymap.set("n", "gt", "<cmd>Glance type_definitions<CR>", opts)

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

      opts.desc = "Line diagnostic"
      keymap.set("n", "<leader>cd", function()
        vim.diagnostic.config({
          virtual_lines = require("config.diagnostic").virtual_lines_config,
          virtual_text = false,
        })

        vim.api.nvim_create_autocmd("CursorMoved", {
          once = true,
          group = vim.api.nvim_create_augroup("line-diagnostics", { clear = true }),
          callback = function()
            vim.diagnostic.config({
              virtual_lines = false,
              virtual_text = require("config.diagnostic").virtual_text_config,
            })
          end,
        })
      end, opts)
    end

    vim.lsp.config("*", {
      on_attach = on_attach,
    })

    vim.lsp.enable({
      "bashls",
      "css_variables",
      "cssls",
      "cssmodules_ls",
      "emmet_language_server",
      "eslint",
      "html",
      "jsonls",
      "lua_ls",
      "marksman",
      "mdx_analyzer",
      "nil_ls",
      "prismals",
      "stylelint_lsp",
      "tailwindcss",
      "ts_query_ls",
      "yamlls",
    })
  end,
}
