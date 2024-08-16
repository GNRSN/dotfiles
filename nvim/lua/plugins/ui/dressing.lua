return {
  -- UI elements for ui.input & ui.select
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("dressing").setup({
        -- NOTE: Has a lot of configuration options

        input = {
          insert_only = false,
          start_in_insert = false,
          win_options = {
            -- Default links to weird groups
            winhighlight = "NormalFloat:Float,FloatBorder:FloatBorder,FloatTitle:FloatTitle",
          },
          -- Default mappings
          mappings = {
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },
        },
      })
    end,
  },
}
