return {
  -- Nicer tab-bar ui
  -- NOTE: I don't think tabs should be used in vim like in other editors, this is still useful for separate window layouts,
  -- e.g. debugger or diff view vs working view
  {
    "nanozuki/tabby.nvim",
    -- VeryLazy would cause it to pop in
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- DOC: At default, neovim only display tabline when there are at least two tab pages.
      -- If you want always display tabline:
      -- vim.o.showtabline = 2

      local palette = require("colorscheme.palette")

      vim.api.nvim_set_keymap("n", "<leader>Ta", ":$tabnew<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>Tx", ":tabclose<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>To", ":tabonly<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>Tn", ":tabn<CR>", { noremap = true })
      vim.api.nvim_set_keymap("n", "<leader>Tp", ":tabp<CR>", { noremap = true })
      -- move current tab to previous position
      vim.api.nvim_set_keymap("n", "<leader>Tmp", ":-tabmove<CR>", { noremap = true })
      -- move current tab to next position
      vim.api.nvim_set_keymap("n", "<leader>Tmn", ":+tabmove<CR>", { noremap = true })

      require("tabby.tabline").use_preset("tab_only", {
        theme = {
          fill = "Normal", -- tabline background
          head = { fg = palette.bg, bg = palette.text_ignored }, -- head element highlight
          current_tab = { fg = palette.bg, bg = palette.fg }, -- current tab label highlight
          tab = { fg = palette.bg, bg = palette.text_ignored }, -- other tab label highlight
          win = { fg = palette.bg, bg = palette.text_ignored }, -- window highlight
          tail = { fg = palette.bg, bg = palette.text_ignored }, -- tail element highlight
        },
        nerdfont = true, -- whether use nerdfont
        lualine_theme = nil, -- lualine theme name
        tab_name = {
          name_fallback = function(tab_id)
            return tab_id
          end,
        },
        buf_name = {
          -- Will show relative path for non-unique file names, e.g. a/index.js & b/index.js
          mode = "unique",
        },
      })
    end,
  },
}
