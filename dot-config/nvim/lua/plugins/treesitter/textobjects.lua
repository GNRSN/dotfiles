return {
  -- Allows parsing and manipulation of textobjects, smarter than just words,
  -- Other extenions may improve their behavior with this enabled
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    event = { "BufReadPre", "BufNewFile" },
  },
}
