return {
  -- Draw indentation lines
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      indent = {
        -- LATER: Was is possible to highlight active scope?
      },
      scope = {
        show_start = false,
        show_end = false,
      },
    },
    config = function(_, opts)
      require("ibl").setup(opts)
    end,
  },
}
