return {
  {
    "mghaight/replua.nvim",
    cmd = {
      "RepluaOpen",
    },
    config = function()
      require("replua").setup()
    end,
  },
}
