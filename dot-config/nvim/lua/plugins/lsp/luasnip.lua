return {
  -- Setup snipet engine
  {
    "L3MON4D3/LuaSnip",
    build = vim.fn.has("win32") ~= 0 and "make install_jsregexp" or nil,
    dependencies = {
      "rafamadriz/friendly-snippets", -- useful snippets
      {
        -- Search snippets
        "benfowler/telescope-luasnip.nvim",
        dependencies = {
          "nvim-telescope/telescope.nvim",
        },
      },
    },
    keys = {
      { "<leader>sS", "<cmd>Telescope luasnip<CR>", desc = "Search snippets" },
    },
    config = function()
      local ls = require("luasnip")

      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load({
        exclude = {
          -- These are general snippets, e.g. `c)` expanding into copywrite statement
          "all",
          -- I use a mix of emmet and custom snippets instead
          "javascript",
          "javascriptreact",
          "jsdoc",
          "typescript",
          "typescriptreact",
          "tsdoc",
          "css",
          "scss",
        },
      })

      -- DOC: friendly-snippets - enable standardized comments snippets
      require("luasnip").filetype_extend("typescript", { "ecma", "tsdoc" })
      require("luasnip").filetype_extend("typescriptreact", { "ecma", "react", "tsdoc" })
      require("luasnip").filetype_extend("javascript", { "ecma", "jsdoc" })
      require("luasnip").filetype_extend("javascriptreact", { "ecma", "react", "jsdoc" })
      require("luasnip").filetype_extend("lua", { "luadoc" })
      require("luasnip").filetype_extend("python", { "pydoc" })
      require("luasnip").filetype_extend("rust", { "rustdoc" })
      require("luasnip").filetype_extend("cs", { "csharpdoc" })
      require("luasnip").filetype_extend("java", { "javadoc" })
      require("luasnip").filetype_extend("c", { "cdoc" })
      require("luasnip").filetype_extend("cpp", { "cppdoc" })
      require("luasnip").filetype_extend("php", { "phpdoc" })
      require("luasnip").filetype_extend("kotlin", { "kdoc" })
      require("luasnip").filetype_extend("ruby", { "rdoc" })
      require("luasnip").filetype_extend("sh", { "shelldoc" })

      -- Register custom snippets
      require("custom_snippets.util").register_snippets()

      -- TJs Snippet expansion keybinds, disabled since I just these keys for nav

      -- -- <c-k> is my expansion key
      -- -- this will expand the current item or jump to the next item within the snippet.
      -- vim.keymap.set({ "i", "s" }, "<c-k>", function()
      --   if ls.expand_or_jumpable() then
      --     ls.expand_or_jump()
      --   end
      -- end, { silent = true })
      --
      -- -- <c-j> is my jump backwards key.
      -- -- this always moves to the previous item within the snippet
      -- vim.keymap.set({ "i", "s" }, "<c-j>", function()
      --   if ls.jumpable(-1) then
      --     ls.jump(-1)
      --   end
      -- end, { silent = true })
      --
      -- -- <c-l> is selecting within a list of options.
      -- -- This is useful for choice nodes (introduced in the forthcoming episode 2)
      -- vim.keymap.set("i", "<c-l>", function()
      --   if ls.choice_active() then
      --     ls.change_choice(1)
      --   end
      -- end)
    end,
  },
}
