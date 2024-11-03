return {
  -- Nvim treesitter version of vim context plugin
  -- Displays current scope at top of buffer, good for long files
  {
    "nvim-treesitter/nvim-treesitter-context",
    -- TODO: Disabled until stable or revert updates
    cond = false,
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>uc", "<Cmd>TSContextToggle<CR>", desc = "Toggle context ui" },
    },
    config = function()
      local separator = nil
      if not require("neovide").ctx_is_neovide() then
        separator = "─"
      end

      require("treesitter-context").setup({
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 12, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = separator,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      })
    end,
  },
}
