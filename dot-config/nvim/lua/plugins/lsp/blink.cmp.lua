return {
  -- Completion
  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
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
    },
    -- use a release tag to download pre-built binaries
    version = "*",
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    cond = vim.g.blink_cmp,

    event = "InsertEnter",

    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      -- See the full "keymap" documentation for information on defining your own keymap.
      keymap = {
        preset = "none",
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        -- REVIEW: I want to learn C-space completion as it seems most efficient
        -- ["<C-i>"] = { "select_and_accept" },
        -- ["<C-y>"] = { "select_and_accept" },
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
      },
      appearance = {
        -- Sets the fallback highlight groups to nvim-cmp's highlight groups
        -- Useful for when your theme doesn't support blink.cmp
        -- Will be removed in a future release
        use_nvim_cmp_as_default = false,
        -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- Adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",

        kind_icons = CMP.icons.kinds,
      },

      completion = {
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
          -- border = "single",
          draw = {
            treesitter = { "lsp" },
            columns = {
              { "kind_icon", "label", "label_description", gap = 0 },
              -- LATER: consider source_id
              { "source_name" },
            },
            components = {
              -- LATER: Re map to shortened id
              -- source_name = {
              --   width = { max = 30 },
              --   text = function(ctx)
              --     return ctx.source_name
              --   end,
              --   highlight = "BlinkCmpSource",
              -- },
            },
          },
        },
        documentation = {
          window = { border = "single" },
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = true,
        },
        trigger = {
          show_on_blocked_trigger_characters = {},
        },
      },

      fuzzy = {
        sorts = {
          function(a, b)
            if a.client_name == nil or b.client_name == nil then
              return
            end
            return b.client_name == "emmet_ls"
          end,
          -- default sorts
          "score",
          "sort_text",
        },
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
          supermaven = {
            kind = "A",
          },
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

      -- add ai_accept to <Tab> key
      -- LATER: I want to learn C-space first completion as it seems most efficient
      --
      -- LATER: There are also doc recipes for showing ai ghost text before completion is opened
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

      -- check if we need to override symbol kinds
      -- LATER: There is a recipe for combining with nvim-web-devicons
      for _, provider in pairs(opts.sources.providers or {}) do
        ---@cast provider blink.cmp.SourceProviderConfig|{kind?:string}
        if provider.kind then
          local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
          local kind_idx = #CompletionItemKind + 1

          CompletionItemKind[kind_idx] = provider.kind
          ---@diagnostic disable-next-line: no-unknown
          CompletionItemKind[provider.kind] = kind_idx

          ---@type fun(ctx: blink.cmp.Context, items: blink.cmp.CompletionItem[]): blink.cmp.CompletionItem[]
          local transform_items = provider.transform_items
          ---@param ctx blink.cmp.Context
          ---@param items blink.cmp.CompletionItem[]
          provider.transform_items = function(ctx, items)
            items = transform_items and transform_items(ctx, items) or items
            for _, item in ipairs(items) do
              item.kind = kind_idx or item.kind
              item.kind_icon = CMP.icons.kinds[item.kind_name] or item.kind_icon or nil
            end
            return items
          end

          -- Unset custom prop to pass blink.cmp validation
          provider.kind = nil
        end
      end

      require("blink.cmp").setup(opts)
    end,
  },
  -- lazydev
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
}
