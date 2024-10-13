local HARPOON_WINDOW_OPTIONS = {
  border = "rounded",
  title_pos = "center",
}

return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local harpoon = require("harpoon")

    harpoon:setup({
      settings = {
        save_on_toggle = true,
      },
    })

    local keymap = vim.keymap
    local wk = require("which-key")

    -- Create keymaps
    keymap.set("n", "<leader>hm", function()
      harpoon:list():add()

      local n_harpoons = 0
      for _ in pairs(harpoon:list().items) do
        n_harpoons = n_harpoons + 1
      end

      vim.notify(string.format("Added file (#%s)", n_harpoons))
    end, { desc = "Harpoon mark" })

    keymap.set("n", "<leader>hn", function()
      harpoon:list():prev()
    end, { desc = "Go to next harpoon mark" })

    keymap.set("n", "<leader>hp", function()
      harpoon:list():next()
    end, { desc = "Go to previous harpoon mark" })

    keymap.set("n", "<leader>hl", function()
      harpoon.ui:toggle_quick_menu(harpoon:list(), HARPOON_WINDOW_OPTIONS)
    end, { desc = "Harpoon toggle list" })

    for i = 1, 9 do
      local key = string.format("<leader>%s", i)
      keymap.set("n", key, function()
        harpoon:list():select(i)
      end, { desc = string.format("Navigate to harpoon (%s)", i) })

      -- Hide from which-key
      wk.register({
        [key] = "which_key_ignore",
      })
    end

    -- LATER: add keybind for attatching a certain harpoon

    -- for i = 1, 9 do
    --   local key = string.format("<leader>h%s", i)
    --   keymap.set("n", key, function()
    --     harpoon:list():removeAt(i)
    --   end, { desc = string.format("Attatch harpoon (%s)", i) })
    --
    --   -- Hide from which-key
    --   wk.register({
    --     [key] = "which_key_ignore",
    --   })
    -- end
  end,
}
