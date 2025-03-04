local palette = require("colorscheme.palette")

function concatTableKeyValuePairs(table)
  local result = ""
  for key, value in pairs(table) do
    result = result .. key .. ":" .. value .. ","
  end
  result = result:sub(1, -2) -- remove the trailing comma
  return result
end

return {
  -- fzf-lua is said to be faster than telescope with fzf native
  {
    "ibhagwan/fzf-lua",
    priority = 100,
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      {
        "<leader><space>",
        function()
          require("fzf-lua").files({ multiprocess = true })
        end,
        desc = "Search files (fzf)",
      },
      {
        "<leader>fs",
        function()
          require("fzf-lua").live_grep({ multiprocess = true })
        end,
        desc = "Grep (fzf)",
      },
      {
        "<leader>fs",
        function()
          require("fzf-lua").grep_visual()
        end,
        mode = { "x" },
        desc = "Grep selection (fzf)",
      },
      {
        "<leader>fg",
        function()
          require("fzf-lua").git_status()
        end,
        desc = "Git status (fzf)",
      },
      {
        "<leader>fr",
        function()
          require("fzf-lua").resume()
        end,
        desc = "Resume search (fzf)",
      },
      {
        "<leader>fR",
        function()
          require("fzf-lua").oldfiles()
        end,
        desc = "Recent files (fzf)",
      },
    },
    opts = {
      winopts = {
        width = 0.9,
        preview = {
          horizontal = "right:50%",
          scrollbar = "border",
        },
      },
      keymap = {
        builtin = { -- uses vim style keys
          ["<C-u>"] = "preview-up",
          ["<C-d>"] = "preview-down",
        },
        fzf = {
          -- Required here again to override self closing on ctrl-d when listing git files
          ["ctrl-u"] = "preview-up",
          ["ctrl-d"] = "preview-down",
          --
          -- Reset selection when updating query,
          -- this opt is passed as the --bind command so this events (seemingly) can't be bound as separate opt
          ["change"] = "top",
        },
      },
      fzf_colors = {
        fg = palette.white, -- Text
        ["fg+"] = palette.fg, -- Text (current line)
        hl = palette.green, -- Highlighted substrings
        ["hl+"] = palette.green, -- Highlighted substrings on current line
        ["bg+"] = palette.visual_bg, -- Current line word background
        gutter = "-1", -- Gutter, just hide it
        prompt = palette.blue_medium, -- Path
        pointer = palette.pink, -- The current line indicator
        spinner = palette.pink, -- The spinner
        info = palette.text_ignored, -- Match counter
        query = palette.yellow, -- Input query
      },
      fzf_opts = {
        ["--layout"] = "default",
        ["--info"] = "inline-right",
        ["--no-separator"] = "",
        ["--scrollbar"] = "█",
        ["--pointer"] = "",
        ["--marker"] = "", -- multi select
        ["--no-bold"] = "",
        ["--tiebreak"] = "end",
      },
      files = {
        fzf_opts = {
          ["--info"] = "inline-right",
        },
      },
      grep = {
        fzf_opts = {
          ["--info"] = "inline-right",
        },
        -- Include hidden files, e.g. .dotfiles
        hidden = true,
      },
    },
  },
}
