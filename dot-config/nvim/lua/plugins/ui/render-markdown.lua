return {
  -- Inline markdown renderer
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      file_types = { "markdown", "Avante" },
      completions = {
        blink = {
          enabled = vim.g.completion == "blink",
        },
      },
      heading = {
        -- If the defaults were used here (Bg suffix),
        -- when setting the background to nil the original default groups still applied
        backgrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
        -- These only applied to the icon, not the actual heading. Renamed accordingly
        foregrounds = {
          "RenderMarkdownH1Icon",
          "RenderMarkdownH2Icon",
          "RenderMarkdownH3Icon",
          "RenderMarkdownH4Icon",
          "RenderMarkdownH5Icon",
          "RenderMarkdownH6Icon",
        },
      },
    },
    ft = { "markdown", "Avante" },
  },
}
