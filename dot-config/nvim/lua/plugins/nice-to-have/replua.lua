return {
  { -- Lua repl experience in scratch buffer
    "mghaight/replua.nvim",
    cmd = {
      "RepluaOpen",
    },
    opts = {
      keymaps = {
        eval_line = "<leader>tr",
        eval_block = nil, -- disable
        eval_buffer = "<leader>tf",
      },
      print_prefix = "-- print: ",
      result_prefix = "-- return: ",
      intro_lines = {
        "-- Lua sandbox",
        "-- run line: <leader>tr",
        "-- run file: <leader>tf",
        "",
        "",
      },
    },
  },
}
