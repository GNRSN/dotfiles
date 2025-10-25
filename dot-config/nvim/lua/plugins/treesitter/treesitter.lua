local ENSURE_INSTALLED = {
  "bash",
  "cpp",
  "css",
  "diff",
  "dockerfile",
  "git_config",
  "git_rebase",
  "gitignore",
  "go",
  "graphql",
  "html",
  "http",
  "java",
  "javascript",
  "jsdoc",
  "json",
  "jsonc",
  "kdl", -- Kotlin Data Language, used to config zellij
  "lua",
  "luadoc",
  "luap", -- Lua patterns
  "markdown",
  "markdown_inline",
  "nix",
  "prisma",
  "query", -- This is the Treesitter query lang
  "regex",
  "rust",
  "scss",
  "sql",
  "ssh_config",
  "svelte",
  "typescript",
  "tsx",
  "toml",
  "vim",
  "vimdoc",
  "vue",
  "xml",
  "yaml",
  "zig",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- NOTE: Main branch is moving rapidly, requires tree-sitter-cli installed
    branch = "main",
    version = false,
    build = ":TSUpdate",
    -- DOC: This plugin does not support lazy-loading
    lazy = false,
    dependencies = {
      { -- Smarter/more correct % and similar actions
        "andymass/vim-matchup",
        ---@type matchup.Config|{}
        opts = {
          ---@diagnostic disable-next-line: missing-fields
          treesitter = {
            stopline = 500,
            disable_virtual_text = true,
          },
          ---@diagnostic disable-next-line: missing-fields
          matchparen = {
            --- Disable feature by setting to empty
            ---@diagnostic disable-next-line: missing-fields
            offscreen = {},
          },
        },
      },
      { -- Automatically inserts "end" keyword to close scopes in languages like lua
        -- DOC: No configuration is required, just install the plugin and it'll work!
        "RRethy/nvim-treesitter-endwise",
      },
      { -- Incremental selection through treesitter
        "daliusd/incr.nvim",
        opts = {
          incr_key = "<C-space>",
          decr_key = "<C-bs>",
        },
      },
    },
    config = function(_, opts)
      local TS = require("nvim-treesitter")
      local already_installed = TS.get_installed("parsers")
      local parsers_to_install = vim
        .iter(ENSURE_INSTALLED)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed, parser)
        end)
        :totable()

      TS.install(parsers_to_install)

      -- LATER: Do i still need this?
      vim.treesitter.language.register("bash", "zsh")
      vim.treesitter.language.register("bash", "conf")

      vim.api.nvim_create_autocmd("FileType", {
        desc = "User: Enable Treesitter for buffer",
        group = vim.api.nvim_create_augroup("user:treesitter", { clear = true }),
        callback = function(ctx)
          local ft, lang = ctx.match, vim.treesitter.language.get_lang(ctx.match)

          -- highlighting
          local has_highlighted = pcall(vim.treesitter.start)

          if not has_highlighted then
            return
          end

          -- indents
          local indent_blacklist = {}
          if not vim.list_contains(indent_blacklist, ctx.match) then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          -- folds
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end,
      })
    end,
  },
}
