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
      -- NOTE: All these integrations do is remap names so that the same
      -- language/service name maps to the corresponding mason registry packages
      integrations = {
        ["mason-lspconfig"] = true,
        ["mason-nvim-dap"] = true,
      },
      ensure_installed = vim.list_extend(
        {
          -- Required by nvim-treesitter to install/compile parsers
          "tree-sitter-cli",

          -- Typescript, managed by typescript-tools
          "ts_ls",

          -- Formatters & linters
          "kdlfmt", -- kdl formatter
          "prettierd", -- js + more formatter
          "shfmt", -- shell formatter
          -- REVIEW: Pin to same version as work as I don't know how to use workspace version
          { "stylelint", version = "15.4.0" }, -- css/less/scss linter
          "stylua", -- lua formatter
        },
        -- LSP
        require("config.lsp-servers")
      ),
    })
  end,
}
