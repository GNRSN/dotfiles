return {
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    opts = {
      show_ignored = true,
      symbols = {
        index = {
          [" "] = "-",
          ["!"] = " ",
        },
        working_tree = {
          [" "] = "-",
          ["!"] = " ",
        },
      },
    },
  },
  -- Navigate directories + vim-like edit to file system
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    cond = true,
    keys = {
      {
        "<BS>",
        function()
          -- LATER: Consider conditioning opening float or in buffer on whether there are splits
          require("oil").toggle_float()
        end,
        desc = "Open parent directory (oil)",
      },
    },
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".." or name == ".git" or name == ".turbo"
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
        border = "rounded",
        win_options = {
          winhighlight = "FloatTitle:OilFloatTitle",
        },
      },
      win_options = {
        -- Required for oil-git-status
        signcolumn = "yes:2",
        wrap = true,
        winblend = 0,
        relativenumber = false,
        number = false,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["<C-h>"] = false,
        ["q"] = "actions.close",
        ["<esc>"] = { "actions.close", mode = "n", desc = "Close" },
        ["<BS>"] = "actions.parent",
      },
    },
    config = function(_, opts)
      -- Oil.nvim recipe for using git status for determining hidden files
      -- DOC: https://github.com/stevearc/oil.nvim/blob/master/doc/recipes.md#hide-gitignored-files-and-show-git-tracked-hidden-files

      -- helper function to parse output
      local function parse_output(proc)
        local result = proc:wait()
        local ret = {}
        if result.code == 0 then
          for line in vim.gsplit(result.stdout, "\n", { plain = true, trimempty = true }) do
            -- Remove trailing slash
            line = line:gsub("/$", "")
            ret[line] = true
          end
        end
        return ret
      end

      -- build git status cache
      local function new_git_status()
        return setmetatable({}, {
          __index = function(self, key)
            local ignore_proc = vim.system(
              { "git", "ls-files", "--ignored", "--exclude-standard", "--others", "--directory" },
              {
                cwd = key,
                text = true,
              }
            )
            local tracked_proc = vim.system({ "git", "ls-tree", "HEAD", "--name-only" }, {
              cwd = key,
              text = true,
            })
            local ret = {
              ignored = parse_output(ignore_proc),
              tracked = parse_output(tracked_proc),
            }

            rawset(self, key, ret)
            return ret
          end,
        })
      end
      local git_status = new_git_status()

      -- Clear git status cache on refresh
      local refresh = require("oil.actions").refresh
      local orig_refresh = refresh.callback
      refresh.callback = function(...)
        git_status = new_git_status()
        orig_refresh(...)
      end

      require("oil").setup(vim.tbl_deep_extend("force", opts, {
        view_options = {
          is_hidden_file = function(name, bufnr)
            local dir = require("oil").get_current_dir(bufnr)
            -- if no local directory (e.g. for ssh connections)
            if not dir then
              return false
            end

            -- Check if file is gitignored
            return git_status[dir].ignored[name]
          end,
        },
      }))
    end,
  },
}
