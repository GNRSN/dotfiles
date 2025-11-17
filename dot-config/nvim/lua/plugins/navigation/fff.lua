return {
  { -- Next gen file-picker, this one powered by frizbee/SIMD
    "dmtrKovalenko/fff.nvim",
    build = function()
      -- DOC: this will download prebuild binary or try to use existing rustup toolchain to build from source
      -- (if you are using lazy you can use gb for rebuilding a plugin if needed)
      require("fff.download").download_or_build_binary()
    end,
    -- DOC: This plugin initializes itself lazily.
    lazy = false,
    keys = {
      { -- Keeping this for now as a way to debug/compare fff-snacks to original UI
        "<leader>ff",
        "<cmd>FFFFind<cr>",
        { desc = "Find files (fff, original UI)" },
      },
    },
    opts = {
      layout = {
        height = 0.8,
        width = 0.9,
        preview_size = 0.4,
      },
      preview = {
        line_numbers = true,
      },
      debug = {
        enabled = false, -- we expect your collaboration at least during the beta
        show_scores = false, -- to help us optimize the scoring system, feel free to share your scores!
      },
    },
  },
  { -- Uses snacks picker as fff frontend
    "madmaxieee/fff-snacks.nvim",
    dependencies = {
      "dmtrKovalenko/fff.nvim",
      "folke/snacks.nvim",
    },
    cmd = "FFFSnacks",
    keys = {
      {
        "<leader><space>",
        "<cmd>FFFSnacks<cr>",
        desc = "Find files (fff)",
      },
    },
    config = true,
  },
}
