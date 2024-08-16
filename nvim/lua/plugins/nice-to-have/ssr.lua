return {
  -- "Structural search and replace"
  -- Treesitter based S&R
  -- Use $name as wildcard
  -- Only searches current file, could be useful for updating tests though
  -- LATER: https://github.com/kevinhwang91/nvim-bqf for a more powerful quickfix list
  {
    "cshuaimin/ssr.nvim",
    keys = {
      {
        "<leader>ss",
        function()
          require("ssr").open()
        end,
        desc = "(SSR) Structural search and replace",
        mode = { "n", "x" },
      },
    },
  },
}
