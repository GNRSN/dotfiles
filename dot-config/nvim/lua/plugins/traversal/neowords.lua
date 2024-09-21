return {
  --
  {
    "Backdround/Neowords.nvim",
    lazy = false,
    config = function()
      -- Config from "Sub words only" example
      local neowords = require("neowords")
      local pattern = neowords.pattern_presets

      local subword_hops = neowords.get_word_hops(
        pattern.snake_case,
        pattern.camel_case,
        pattern.upper_case,
        pattern.number,
        pattern.hex_color
      )

      vim.keymap.set({ "n", "x", "o" }, "w", subword_hops.forward_start)
      vim.keymap.set({ "n", "x", "o" }, "e", subword_hops.forward_end)
      vim.keymap.set({ "n", "x", "o" }, "b", subword_hops.backward_start)
      vim.keymap.set({ "n", "x", "o" }, "ge", subword_hops.backward_end)
    end,
  },
}
