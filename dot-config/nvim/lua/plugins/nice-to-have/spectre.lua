return {
  -- Search and replace panel
  -- NOTE: Default requires ripgrep and sed or oxi installed
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "noib3/nvim-oxi" },
    },
    keys = {
      {
        "<leader>R",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre",
      },
      {
        "<leader>R",
        function()
          require("spectre").open_visual()
        end,
        desc = "Spectre",
        mode = { "x" },
      },
      -- REVIEW: Can add more keymaps for eg search for current selection in visual mode
    },
    config = function()
      require("spectre").setup({
        color_devicons = true,
        live_update = true, -- auto execute search again when you write any file in vim
        default = {
          replace = {
            -- Default to using oxi
            cmd = "oxi",
          },
        },
      })
    end,
  },
}
