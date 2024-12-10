return {
  "williamboman/mason.nvim",
  dependencies = {
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

    mason_lspconfig.setup({
      -- list of servers for mason to install
      ensure_installed = {
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
        "tailwindcss",
        "ts_ls",
        "yamlls",
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "black", -- python formatter
        "isort", -- python formatter
        "prettierd", -- js + more formatter
        "pylint", -- python linter
        "shfmt", -- shell formatter
        "stylua", -- lua formatter
      },
    })
  end,
}
