-- check if current line is inside a comment block
-- DOC: Copied from https://github.com/Saghen/blink.cmp/pull/1354
local function inside_comment_block()
  if vim.api.nvim_get_mode().mode ~= "i" then
    return false
  end
  local node_under_cursor = vim.treesitter.get_node()
  local parser = vim.treesitter.get_parser(nil, nil, { error = false })
  local query = parser and vim.treesitter.query.get(parser:lang(), "highlights")
  if not parser or not node_under_cursor or not query then
    return false
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  for id, node, _ in query:iter_captures(node_under_cursor, 0, row, row + 1) do
    if query.captures[id]:find("comment") then
      local start_row, start_col, end_row, end_col = node:range()
      if start_row <= row and row <= end_row then
        if start_row == row and end_row == row then
          if start_col <= col and col <= end_col then
            return true
          end
        elseif start_row == row then
          if start_col <= col then
            return true
          end
        elseif end_row == row then
          if col <= end_col then
            return true
          end
        else
          return true
        end
      end
    end
  end
  return false
end

local MENU_MAPPER = {
  Buffer = "Buf",
  LSP = "Lsp",
  codeium = "[ai]",
  supermaven = "[ai]",
  npm = "npm",
  Cmdline = "Cmd",
  Snippets = "Snip",
}

local CLIENT_NAME_MAPPER = {
  emmet_language_server = "emmet",
  ["typescript-tools"] = "typescript",
}

---@param ctx blink.cmp.DrawItemContext
local function get_source_label(ctx)
  return CLIENT_NAME_MAPPER[ctx.item.client_name]
    or ctx.item.client_name
    or MENU_MAPPER[ctx.source_name]
    or ctx.source_name
end

return {
  {
    "saghen/blink.compat",
    -- use v2.* for blink.cmp v1.*
    version = "2.*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    "saghen/blink.cmp",
    -- optional: provides snippets for the snippet source
    dependencies = {
      "rafamadriz/friendly-snippets",
      -- DOC: Make sure you're using the latest release of LuaSnip, `main` does not work at the moment
      { "L3MON4D3/LuaSnip", version = "v2.*" },
      { "Kaiser-Yang/blink-cmp-avante" },
      -- LATER: Consider https://github.com/Kaiser-Yang/blink-cmp-git for octo
    },

    -- use a release tag to download pre-built binaries
    version = "1.*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',
    event = {
      "InsertEnter",
      "CmdlineEnter",
    },

    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "none",
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-space>"] = { "show", "accept" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<C-n>"] = { "select_next", "fallback" },
        ["<C-q>"] = { "hide", "fallback" },
        -- Temp until mapping with AI accept
        ["<tab>"] = { "snippet_forward", "fallback" },
        ["<s-tab>"] = { "snippet_backward", "fallback" },
      },

      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        kind_icons = require("config.icons").kinds,
      },

      completion = {
        keyword = {
          range = "prefix",
        },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        list = {
          selection = {
            auto_insert = false,
            preselect = true,
          },
        },

        menu = {
          -- not working
          auto_show = function(ctx, items)
            return not inside_comment_block()
          end,
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 0 },
              { "kind_icon", "source_name" },
            },
            components = {
              source_name = {
                width = { max = 30 },
                text = get_source_label,
                highlight = "BlinkCmpSource",
              },
              -- Use nvim-web-devicons for file imports
              kind_icon = {
                text = function(ctx)
                  local icon = ctx.kind_icon
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      icon = dev_icon
                    end
                  -- Custom "kinds" for AI sources
                  elseif ctx.source_name == "supermaven" then
                    icon = require("config.icons").kinds.Supermaven
                  elseif ctx.source_name == "codeium" then
                    icon = require("config.icons").kinds.Codeium
                  end

                  return icon .. ctx.icon_gap
                end,

                -- Optionally, use the highlight groups from nvim-web-devicons
                -- You can also add the same function for `kind.highlight` if you want to
                -- keep the highlight groups in sync with the icons.
                highlight = function(ctx)
                  local hl = ctx.kind_hl
                  if vim.tbl_contains({ "Path" }, ctx.source_name) then
                    local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                    if dev_icon then
                      hl = dev_hl
                    end
                  end
                  return hl
                end,
              },
            },
          },
        },
        documentation = {
          window = { border = "single" },
          auto_show = false,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = function()
            return not inside_comment_block()
          end,
        },
      },

      -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
      -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
      -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
      --
      -- See the fuzzy documentation for more information
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        -- TODO: Can't use custom lua sort for emmet, consider the implications for emmet usage
        -- DOC: If you are using the Rust implementation but specify a custom Lua function for sorting,
        -- the sorting process will fall back to Lua instead of being handled by Rust.
        -- LATER: remove emmet guessing react components based on capital letter
        -- sorts = {
        --   function(a, b)
        --     if a.client_name == nil or b.client_name == nil then
        --       return
        --     end
        --     return a.client_name == "emmet_ls"
        --   end,
        --   -- DOC: (optionally) always prioritize exact matches
        --   "exact",
        --   -- default sorts
        --   "score",
        --   "sort_text",
        -- },
      },

      signature = {
        enabled = true,
        window = { border = "single" },
      },

      snippets = { preset = "luasnip" },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        -- NOTE: Non standard option that will be transformed in the config function
        compat = {
          "supermaven",
          "codeium",
        },
        default = {
          "lsp",
          "path",
          "snippets",
          "buffer",
        },
        providers = {
          supermaven = {},
          lsp = {
            override = {
              -- DOC: enable whitespace as completion trigger
              get_trigger_characters = function(self)
                local trigger_characters = self:get_trigger_characters()
                vim.list_extend(trigger_characters, { "\n", "\t", " " })
                return trigger_characters
              end,
            },
          },
        },
      },

      cmdline = {
        enabled = true,
        completion = {
          list = {
            selection = {
              auto_insert = false,
              preselect = true,
            },
          },
          menu = {
            auto_show = true,
          },
        },
        keymap = {
          preset = "none",
          ["<C-space>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.accept()
              else
                return cmp.show()
              end
            end,
          },
          ["<C-p>"] = { "select_prev", "fallback" },
          ["<C-n>"] = { "select_next", "fallback" },
          ["<C-q>"] = { "hide", "fallback" },
          ["<CR>"] = {
            -- HACK: workaround, I experienced menu often getting stuck after entering command
            function(cmp)
              cmp.hide()
              return false
            end,
            "fallback",
          },
        },
      },

      term = {
        enabled = true,
      },
    },

    ---@param opts blink.cmp.Config | { sources: { compat: string[] } }
    config = function(_, opts)
      -- Disable native completion
      vim.opt.complete = ""

      -- setup compat sources
      local enabled = opts.sources.default
      for _, source in ipairs(opts.sources.compat or {}) do
        opts.sources.providers[source] = vim.tbl_deep_extend(
          "force",
          { name = source, module = "blink.compat.source" },
          opts.sources.providers[source] or {}
        )
        if type(enabled) == "table" and not vim.tbl_contains(enabled, source) then
          table.insert(enabled, source)
        end
      end

      -- LATER: add ai_accept to <Tab> key
      -- There are also doc recipes for showing ai ghost text before completion is opened
      --
      if not opts.keymap["<Tab>"] then
        -- if opts.keymap.preset == "super-tab" then -- super-tab
        --   opts.keymap["<Tab>"] = {
        --     require("blink.cmp.keymap.presets")["super-tab"]["<Tab>"][1],
        --     CMP.map({ "snippet_forward", "ai_accept" }),
        --     "fallback",
        --   }
        -- else -- other presets
        --   opts.keymap["<Tab>"] = {
        --     CMP.map({ "snippet_forward", "ai_accept" }),
        --     "fallback",
        --   }
        -- end
      end

      -- Unset custom prop to pass blink.cmp ops validation
      opts.sources.compat = nil

      require("blink.cmp").setup(opts)
    end,
  },
  -- Lazydev
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        -- add lazydev to your completion providers
        default = { "lazydev" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100, -- show at a higher priority than lsp
          },
        },
      },
    },
  },
  -- Avante
  {
    "saghen/blink.cmp",
    opts = {
      sources = {
        default = { "avante" },
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
        },
      },
    },
  },
}
