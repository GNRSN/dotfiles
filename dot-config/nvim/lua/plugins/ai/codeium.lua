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
}
