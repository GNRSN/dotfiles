return {
  -- Draw indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      -- LATER: I wasn't happy with the default behavior where all lines are rainbow all the time,
      -- as opposed to only highlighting the active scope with its corresponding rainbow color

      -- local highlight = {
      --   -- This order mimics vs-code
      --   "RainbowDelimiterYellowMuted",
      --   "RainbowDelimiterVioletMuted",
      --   "RainbowDelimiterBlueMuted",
      -- }

      require("ibl").setup({
        indent = {
          --   highlight = highlight,
        },
        scope = {
          show_start = false,
          show_end = false,
        },
      })
    end,
  },
}
