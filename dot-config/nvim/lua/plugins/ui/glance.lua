return {
  -- UI for listing options for e.g. lsp find references
  {
    "dnlhc/glance.nvim",
    config = function()
      local glance = require("glance")
      local actions = glance.actions

      ---@diagnostic disable-next-line: missing-fields
      require("glance").setup({
        border = {
          enable = true,
        },
        ---@diagnostic disable-next-line: missing-fields
        folds = {
          -- Default to unfolded on open
          folded = false,
        },
        ---@diagnostic disable-next-line: missing-fields
        mappings = {
          list = {
            -- ["j"] = false,
            -- ["k"] = false,
            ["<C-n>"] = actions.next_location,
            ["<C-p>"] = actions.previous_location,
          },
        },
        ---@diagnostic disable-next-line: missing-fields
        hooks = {
          -- Skip opening if there is only 1 options
          -- NOTE: There is also a version to only skip if the option is in the same file but this is what I'm used to
          before_open = function(results, open, jump, method)
            if #results == 1 then
              jump(results[1]) -- argument is optional
            else
              open(results) -- argument is optional
            end
          end,
        },
      })
    end,
  },
}
