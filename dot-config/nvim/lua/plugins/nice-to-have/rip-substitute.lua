return {
  {
    "chrisgrieser/nvim-rip-substitute",
    cmd = "RipSubstitute",
    opts = {},
    keys = {
      {
        "<leader>fR",
        function()
          require("rip-substitute").sub()
        end,
        mode = { "n", "x" },
        desc = " Find & replace (rip substitute)",
      },
    },
  },
}
