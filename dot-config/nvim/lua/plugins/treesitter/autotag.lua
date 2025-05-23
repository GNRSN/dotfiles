return {
  { --
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    cond = true,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {
      enable_close = true,
      enable_rename = true,
      enable_close_on_slash = true,
    },
  },
}
