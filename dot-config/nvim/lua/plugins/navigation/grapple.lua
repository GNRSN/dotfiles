return {
  -- Harpoon replacement
  {
    "cbochs/grapple.nvim",
    dependencies = {
      { "nvim-tree/nvim-web-devicons", lazy = true },
    },
    event = { "BufReadPost", "BufNewFile" },
    cmd = "Grapple",
    keys = {
      {
        "<leader>hm",
        function()
          local existing = require("grapple").name_or_index()
          require("grapple").toggle()
          local name_or_index = require("grapple").name_or_index()
          if name_or_index then
            vim.notify("Grapple: " .. name_or_index)
          elseif existing then
            vim.notify("Removed (" .. existing .. ")")
          else
            vim.notify("Unknown Grapple effect", vim.log.levels.WARN)
          end
        end,
        desc = "Grapple toggle tag",
      },
      { "<leader>hl", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple open tags window" },
      { "<leader>hn", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
      { "<leader>hp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },

      { "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "which_key_ignore" },
      { "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "which_key_ignore" },
      { "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "which_key_ignore" },
      { "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "which_key_ignore" },
      { "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "which_key_ignore" },
      { "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "which_key_ignore" },
      { "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "which_key_ignore" },
      { "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "which_key_ignore" },
      { "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "which_key_ignore" },
    },
    config = function()
      local project_uses_graphite = require("util.local-config").get_workspace_config().graphite
      require("grapple").setup({
        -- Since graphite will mean we change branch a lot, default to scoping saved marks for the repo
        scope = project_uses_graphite and "git" or "git_branch",
      })
    end,
  },
}
