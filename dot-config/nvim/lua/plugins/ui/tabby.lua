return {
  -- Nicer tab-bar ui
  -- NOTE: I don't think tabs should be used in vim like in other editors, this is still useful for separate window layouts,
  -- e.g. debugger or diff view vs working view
  {
    "nanozuki/tabby.nvim",
    -- VeryLazy would cause it to pop in
    event = "VimEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    keys = {
      { "<leader>Ta", ":$tabnew<CR>", noremap = true, desc = "New tab" },
      { "<leader>Tx", ":tabclose<CR>", noremap = true, desc = "Close current tab" },
      { "<leader>To", ":tabonly<CR>", noremap = true, desc = "Close all but current tab" },
      { "<leader>Tn", ":tabn<CR>", noremap = true, desc = "Next tab" },
      { "<leader>TN", ":tabp<CR>", noremap = true, desc = "Previous tab" },
      { "<leader>Tmp", ":-tabmove<CR>", noremap = true, desc = "Move tab left" },
      { "<leader>Tmn", ":+tabmove<CR>", noremap = true, desc = "Move tab right" },
      { "<leader>T1", ":tabnext1<CR>", noremap = true, desc = "Go to tab 1" },
      { "<leader>T2", ":tabnext2<CR>", noremap = true, desc = "Go to tab 2" },
      { "<leader>T3", ":tabnext3<CR>", noremap = true, desc = "Go to tab 3" },
      { "<leader>T4", ":tabnext4<CR>", noremap = true, desc = "Go to tab 4" },
      { "<leader>T5", ":tabnext5<CR>", noremap = true, desc = "Go to tab 5" },
      { "<leader>T6", ":tabnext6<CR>", noremap = true, desc = "Go to tab 6" },
      { "<leader>T7", ":tabnext7<CR>", noremap = true, desc = "Go to tab 7" },
      { "<leader>T8", ":tabnext8<CR>", noremap = true, desc = "Go to tab 8" },
      { "<leader>T9", ":tabnext9<CR>", noremap = true, desc = "Go to tab 9" },
    },
    config = function()
      -- DOC: At default, neovim only display tabline when there are at least two tab pages.
      -- If you want always display tabline:
      -- vim.o.showtabline = 2

      local palette = require("colorscheme.palette")

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
