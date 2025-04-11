return {
  {
    "Exafunction/codeium.nvim",
    cond = function()
      return require("util.local-config").is_work_dir()
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
        -- nvim-cmp is providing this functionality already
        enabled = false,
      },
    },
  },
  -- add ai_accept action
  {
    "Exafunction/codeium.nvim",
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

  {
    "saghen/blink.cmp",
    optional = true,
    dependencies = { "codeium.nvim", "saghen/blink.compat" },
    opts = {
      sources = {
        compat = { "codeium" },
        providers = {
          codeium = {
            kind = "Codeium",
            score_offset = 100,
            async = true,
          },
        },
      },
    },
  },
}
