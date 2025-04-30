return {
  "williamboman/mason.nvim",
  dependencies = {
    "jay-babu/mason-nvim-dap.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        border = "single",
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
        keymaps = {
          toggle_help = "h",
          toggle_package_expand = "<CR>",
          install_package = "i",
          update_package = "i",
          check_package_version = "c",
          update_all_packages = "U",
          check_outdated_packages = "R",
          uninstall_package = "dd",
          cancel_installation = "<C-c>",
          apply_language_filter = "<C-f>",
          toggle_package_install_log = "<CR>",
        },
      },
    })

    mason_tool_installer.setup({
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-nvim-dap"] = true,
      },
      ensure_installed = {
        -- Lsp
        "bashls",
        "css_variables",
        "cssls",
        "cssmodules_ls",
        "emmet_language_server",
        "eslint",
        "graphql",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "mdx_analyzer",
        "nil_ls",
        "prismals",
        "pyright",
        "svelte",
        "stylelint_lsp",
        "tailwindcss",
        "ts_ls", -- Typescript
        "ts_query_ls", -- Treesitter query language
        "yamlls",

        -- Formatters & linters
        "black", -- python formatter
        "isort", -- python formatter
        "prettierd", -- js + more formatter
        "pylint", -- python linter
        "shfmt", -- shell formatter
        -- REVIEW: Pin to same version as work as I don't know how to use workspace version
        { "stylelint", version = "15.4.0" }, -- css/less/scss linter
        "stylua", -- lua formatter
      },
    })
  end,
}
