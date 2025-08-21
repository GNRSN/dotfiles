return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- Smarter % matching lua keywords denoting scopes
      {
        "andymass/vim-matchup",
        init = function()
          -- Disables this feature, it flickers more than it is useful
          vim.g.matchup_matchparen_offscreen = {}
        end,
      },
      -- Automatically inserts "end" keyword to close scopes in languages like lua
      {
        "RRethy/nvim-treesitter-endwise",
      },
    },
    build = ":TSUpdate",
    opts = { -- enable syntax highlighting
      highlight = {
        enable = true,
      },
      -- enable indentation
      indent = {
        enable = true,
      },
      autotag = {
        -- This is supposed to suppress the warning but i'm still seeing it?
        enable = false,
      },
      endwise = {
        enable = true,
      },
      matchup = {
        enable = true,
        disable_virtual_text = true,
      },
      -- ensure these language parsers are installed
      ensure_installed = {
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
    },
    config = function(_, opts)
      -- configure treesitter
      require("nvim-treesitter.configs").setup(opts)

      -- No mdx treesitter grammar available
      ---@see https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
      ---@see https://www.in2deep.xyz/posts/astro-development-using-nvim/

      vim.filetype.add({
        extension = {
          mdx = "markdown.mdx",
        },
      })

      vim.treesitter.language.register("bash", "zsh")
      vim.treesitter.language.register("bash", "conf")
    end,
  },
}
