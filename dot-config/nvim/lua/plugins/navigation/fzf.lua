local palette = require("colorscheme.palette")

function concatTableKeyValuePairs(table)
  local result = ""
  for key, value in pairs(table) do
    result = result .. key .. ":" .. value .. ","
  end
  result = result:sub(1, -2) -- remove the trailing comma
  return result
end

local GREP_IGNORE_LIST = {
  "package_lock.json",
  "pnpm-lock.yaml",
  ".git/*",
}

function build_ripgrep_ignore_globs(ignoreList)
  local result = ""
  for _, value in ipairs(ignoreList) do
    result = result .. "-g '!" .. value .. "' "
  end
  return result
end

return {
  -- Fast picker
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      {
        "<leader><space>",
        function()
          require("fzf-lua").files()
        end,
        desc = "Search files (fzf)",
      },
      {
        "<leader>fs",
        function()
          require("fzf-lua").live_grep()
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
    opts = function(_, opts)
      local fzf = require("fzf-lua")
      local config = fzf.config
      local actions = fzf.actions

      -- From LazyVim https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/fzf.lua#L84
      -- Toggle root dir / cwd
      config.defaults.actions.files["ctrl-r"] = function(_, ctx)
        local o = vim.deepcopy(ctx.__call_opts)
        o.root = o.root == false
        o.cwd = nil
        o.buf = ctx.__CTX.bufnr

        if not o.root then
          o.cwd = require("util.find-root").get({ buf = opts.buf })
        end

        fzf[ctx.__INFO.cmd](o)
      end
      config.set_action_helpstr(config.defaults.actions.files["ctrl-r"], "toggle-root-dir")

      return {
        defaults = {
          -- I do not love this, but it helps a lot in vertical split panes
          formatter = "path.filename_first",
        },
        oldfiles = {
          include_current_session = true,
        },
        winopts = {
          width = 0.9,
          preview = {
            horizontal = "right:50%",
            scrollbar = "border",
          },
        },
        previewers = {
          builtin = {
            -- Avoid trying to display huge files
            syntax_limit_b = 1024 * 100, -- 100KB
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

            -- use cltr-q to select all items and convert to quickfix list
            ["ctrl-q"] = "select-all+accept",

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
          ["--gutter"] = " ", -- set gutter character to space
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
          -- Lets try this
          git_icons = true,
          -- Include hidden files, e.g. .dotfiles
          hidden = true,
          -- Since we include .prefix files we need to ignore some, we also want to ignore venodred files, etc...
          rg_opts = build_ripgrep_ignore_globs(GREP_IGNORE_LIST)
            .. "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
          -- cmd = "rg --vimgrep --hidden --glob '!.git/**'", -- Explicitly exclude staging/
        },
      }
    end,
  },
}
