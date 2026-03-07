local ENSURE_INSTALLED = {
  "applescript",
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
  "zsh",
}

-- NOTE: Pinned to avoid supply chain attacks
local CUSTOM_PARSERS = {
  applescript = {
    "waddie/tree-sitter-applescript",
    url = "https://github.com/waddie/tree-sitter-applescript",
    commit = "adff3f4de87033350050232c8dd23947c7b34850",
  },
}

local CUSTOM_FT_MAPPINGS = {
  conf = "bash",
  osascript = "applescript",
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
    dependencies = vim.list_extend({
      { -- Smarter/more correct % and similar actions
        "andymass/vim-matchup",
        opts = {
          treesitter = {
            stopline = 500,
            disable_virtual_text = true,
          },
          matchparen = {
            --- Disable feature by setting to empty
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
    }, vim.tbl_values(CUSTOM_PARSERS)),
    config = function(_, opts)
      vim.api.nvim_create_autocmd("User", {
        desc = "User: Add treesitter custom parsers",
        pattern = "TSUpdate",
        callback = function()
          for lang, spec in pairs(CUSTOM_PARSERS) do
            require("nvim-treesitter.parsers")[lang] = {
              tier = 2,
              install_info = {
                url = spec.url,
                revision = spec.commit, -- commit hash for revision to check out; HEAD if missing
                -- optional entries:
                -- branch = "main", -- only needed if different from default branch
                -- location = "parser", -- only needed if the parser is in subdirectory of a "monorepo"
                generate = false, -- only needed if repo does not contain pre-generated `src/parser.c`
                generate_from_json = false, -- only needed if repo does not contain `src/grammar.json` either
                queries = "queries", -- also install queries from given directory
              },
            }
          end
        end,
      })

      for lang in pairs(CUSTOM_PARSERS) do
        -- vim.treesitter.language.add(lang, { path = require("lazy"). })
        vim.treesitter.language.register(lang, lang)
        vim.notify("vim.treesitter.language.register: " .. lang)
      end

      for ft, lang in pairs(CUSTOM_FT_MAPPINGS) do
        vim.treesitter.language.register(lang, ft)
      end

      local already_installed = require("nvim-treesitter").get_installed("parsers")
      local parsers_to_install = vim
        .iter(ENSURE_INSTALLED)
        :filter(function(parser)
          return not vim.tbl_contains(already_installed, parser)
        end)
        :totable()

      require("nvim-treesitter").install(parsers_to_install)

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
