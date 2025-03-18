local palette = require("colorscheme.palette")

return {
  {
    "GeorgesAlkhouri/nvim-aider",
    dependencies = {
      "folke/snacks.nvim",
      --- The below dependencies are optional
      --- Neo-tree integration
      -- {
      --   "nvim-neo-tree/neo-tree.nvim",
      --   opts = function(_, opts)
      --     -- Example mapping configuration (already set by default)
      --     -- opts.window = {
      --     --   mappings = {
      --     --     ["+"] = { "nvim_aider_add", desc = "add to aider" },
      --     --     ["-"] = { "nvim_aider_drop", desc = "drop from aider" }
      --     --   }
      --     -- }
      --     require("nvim_aider.neo_tree").setup(opts)
      --   end,
      -- },
    },
    cmd = {
      "AiderTerminalToggle",
      "AiderHealth",
    },
    keys = {
      { "<leader>a/", "<cmd>AiderTerminalToggle<cr>", desc = "Open Aider" },
      { "<leader>as", "<cmd>AiderTerminalSend<cr>", desc = "Send to Aider", mode = { "n", "v" } },
      { "<leader>ac", "<cmd>AiderQuickSendCommand<cr>", desc = "Send Command To Aider" },
      { "<leader>ab", "<cmd>AiderQuickSendBuffer<cr>", desc = "Send Buffer To Aider" },
      { "<leader>a+", "<cmd>AiderQuickAddFile<cr>", desc = "Add File to Aider" },
      { "<leader>a-", "<cmd>AiderQuickDropFile<cr>", desc = "Drop File from Aider" },
      { "<leader>ar", "<cmd>AiderQuickReadOnlyFile<cr>", desc = "Add File as Read-Only" },
    },
    opts = {
      -- Command that executes Aider
      aider_cmd = "aider",
      -- Command line arguments passed to aider
      args = {
        "--no-auto-commits",
        "--pretty",
        "--stream",
      },
      theme = {
        user_input_color = palette.pink,
        tool_output_color = palette.text_ignored,
        tool_error_color = palette.bright_red,
        tool_warning_color = palette.yellow_sunflower,
        assistant_output_color = palette.blue_light,
        completion_menu_color = palette.blue_medium,
        completion_menu_bg_color = palette.selection,
        completion_menu_current_color = palette.fg,
        completion_menu_current_bg_color = palette.visual_bg,
      },
      -- snacks.picker.layout.Config configuration
      picker_cfg = {
        preset = "vscode",
      },
      -- Other snacks.terminal.Opts options
      config = {
        os = { editPreset = "nvim-remote" },
        gui = { nerdFontsVersion = "3" },
      },
      win = {
        wo = { winbar = "Aider" },
        style = "nvim_aider",
        position = "right",
      },
    },
  },
}
