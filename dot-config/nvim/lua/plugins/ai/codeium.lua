local is_windsurf_enabled = require("util.local-config").is_work_dir()

return {
  {
    "Exafunction/windsurf.nvim",
    cond = function()
      return is_windsurf_enabled
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = { "InsertEnter", "CmdlineEnter" },
    cmd = { "Codeium" },
    opts = {
      enable_chat = true,
      enable_cmp_source = true,
      virtual_text = {
        -- completion plugin is providing this functionality already
        enabled = false,
      },
    },
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
  },
  -- add ai_accept action
  {
    "Exafunction/windsurf.nvim",
    opts = function()
      CMP.register_action("ai_accept", function()
        if require("codeium.virtual_text").get_current_completion_item() then
          CMP.create_undo()
          vim.api.nvim_input(require("codeium.virtual_text").accept())
          return true
        end
      end)
    end,
  },

  is_windsurf_enabled
      and {
        "saghen/blink.cmp",
        optional = true,
        dependencies = {
          "Exafunction/windsurf.nvim",
        },
        opts = {
          sources = {
            default = { "codeium" },
            providers = {
              codeium = {
                -- Recommended
                name = "Codeium",
                module = "codeium.blink",
                async = true,
                -- from LazyVim
                kind = "Codeium",
                score_offset = 100,
              },
            },
          },
        },
      }
    or nil,
}
