return {
  -- Search and replace from panel ui
  -- NOTE: Default requires ripgrep and sed or oxi installed
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "noib3/nvim-oxi" },
    },
    -- The build script relies on nvim-oxi to build an oxi-spectre module that is used by the plugin
    -- NOTE: Requires rust toolchain in environment
    -- NOTE: I think this means that updating nvim-oxi only will require a manual run of the script for the updates
    -- to actually effect anything since it's just a build depencency
    build = "./build.sh",
    keys = {
      {
        "<leader>rr",
        function()
          require("spectre").toggle()
        end,
        desc = "Spectre",
      },
      {
        "<leader>rr",
        function()
          require("spectre").open_visual()
        end,
        desc = "Spectre",
        mode = { "x" },
      },
      {
        "<leader>rw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "Search current word",
      },
      {
        "<leader>rw",
        function()
          require("spectre").open_visual()
        end,
        desc = "Search current word",
        mode = { "v" },
      },
      {
        "<leader>rp",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "Search on current file",
      },
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
        is_block_ui_break = true,
      })
    end,
  },
}
