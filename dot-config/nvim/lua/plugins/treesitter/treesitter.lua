return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- import nvim-treesitter plugin
      local treesitter = require("nvim-treesitter.configs")

      -- configure treesitter
      ---@diagnostic disable-next-line: missing-fields (Type requires all config properties)
      treesitter.setup({ -- enable syntax highlighting
        highlight = {
          enable = true,
        },
        -- enable indentation
        indent = {
          enable = true,
        },
        -- enable autotagging (w/ nvim-ts-autotag plugin)
        autotag = {
          enable = true,
        },
        -- ensure these language parsers are installed
        ensure_installed = {
          "bash",
          "css",
          "dockerfile",
          "gitignore",
          "go",
          "graphql",
          "html",
          "javascript",
          "jsdoc",
          "json",
          "jsonc",
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
          "svelte",
          "typescript",
          "tsx",
          "toml",
          "yaml",
          "vim",
          "vimdoc",
          "zig",
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",
            node_incremental = "<C-space>",
            scope_incremental = false,
            node_decremental = "<bs>",
          },
        },
      })

      -- No mdx treesitter grammar available
      ---@see https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
      ---@see https://www.in2deep.xyz/posts/astro-development-using-nvim/

      vim.filetype.add({
        extension = {
          mdx = "markdown.mdx",
        },
      })

      vim.treesitter.language.register("bash", "zsh")
    end,
  },
}
