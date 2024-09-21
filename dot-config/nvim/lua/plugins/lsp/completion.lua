return {
  "hrsh7th/nvim-cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    -- Basics
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    -- Lsp
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-nvim-lsp-signature-help",
    "onsails/lspkind.nvim", -- pictograms
    "js-everts/cmp-tailwind-colors",
    -- Snippets
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    -- Misc integrations
    {
      "petertriho/cmp-git",
      requires = "nvim-lua/plenary.nvim",
    },

    {
      "David-Kunz/cmp-npm",
      dependencies = { "nvim-lua/plenary.nvim" },
      ft = "json",
      config = function()
        require("cmp-npm").setup({})
      end,
    },
  },
  config = function()
    -- Disable native completion
    vim.opt.complete = ""

    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    cmp.setup({
      completion = {
        -- Define completion behavior
        -- menu,menuone: show menu, even when there is only 1 option
        -- preview: show additional information in preview window
        completeopt = "menu,menuone,preview",
      },
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      window = {
        completion = cmp.config.window.bordered({
          -- account/offset for icon/kind as prefix
          col_offset = -2,
          side_padding = 0,
        }),
        documentation = cmp.config.window.bordered(),
      },

      snippet = {
        -- Register luasnip as our snippet engine of choice
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- sources for autocompletion
      -- NOTE: order of sources effect order in UI
      sources = cmp.config.sources({
        {
          -- optional completion source for require statements and module annotations
          name = "lazydev",
          group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        },
        { name = "npm", keyword_length = 4 },
        { name = "nvim_lsp_signature_help" },
        { name = "codeium" },
        { name = "path" },
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" }, -- snippets
        {
          name = "buffer",
          keyword_length = 4,
        },
        {
          -- Adding this to use with Octo.nvim
          name = "git",
        },
      }, {}),
      enabled = function()
        -- disable completion in comments
        local is_allowed_context = true

        local context = require("cmp.config.context")
        -- keep command mode completion enabled when cursor is in a comment
        if vim.api.nvim_get_mode().mode == "c" then
          is_allowed_context = true
        else
          -- is_allowed_context = not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
          local disabled = false
          disabled = disabled or (vim.api.nvim_buf_get_option(0, "buftype") == "prompt")
          disabled = disabled or (vim.fn.reg_recording() ~= "")
          disabled = disabled or (vim.fn.reg_executing() ~= "")
          disabled = disabled or context.in_treesitter_capture("comment")
          disabled = disabled or context.in_syntax_group("Comment")
          is_allowed_context = not disabled
        end

        -- disable completion for certain commands
        local is_allowed_command = true
        -- Set of commands where cmp will be disabled
        local disabled_commands = {
          IncRename = true,
        }
        -- Get first word of cmdline
        local cmd = vim.fn.getcmdline():match("%S+")
        -- Return true if cmd isn't disabled
        -- else call/return cmp.close(), which returns false
        is_allowed_command = not disabled_commands[cmd] or cmp.close()

        -- disable completion for certain buffers

        return is_allowed_context and is_allowed_command
      end,
      mapping = cmp.mapping.preset.insert({
        -- NOTE: TJs mappings
        ["<C-n>"] = cmp.mapping.select_next_item({
          -- behavior = cmp.SelectBehavior.Insert
          behavior = cmp.SelectBehavior.Select,
        }),
        ["<C-p>"] = cmp.mapping.select_prev_item({
          -- behavior = cmp.SelectBehavior.Insert
          behavior = cmp.SelectBehavior.Select,
        }),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<C-q>"] = cmp.mapping.abort(),

        ["<C-i>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() then
              -- Insert undo breakpoint so completion can be undone
              local CTRLg_u = vim.api.nvim_replace_termcodes("<C-g>u", true, true, true)
              vim.api.nvim_feedkeys(CTRLg_u, "n", true)
              return cmp.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
              })
            end

            fallback()
          end,
          c = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
        }),
        -- LATER: This mapping from docs explains how to combine with snipped expansion (Designed for <tab> though)
        --
        -- ["<C-i>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --   -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
        --   -- that way you will only jump inside the snippet region
        --   elseif luasnip.expand_or_locally_jumpable() then
        --     luasnip.expand_or_jump()
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        ["<M-i>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          { "i", "c" }
        ),

        ["<c-space>"] = cmp.mapping({
          i = cmp.mapping.complete(),
          c = function(
            _ --[[fallback]]
          )
            if cmp.visible() then
              if not cmp.confirm({ select = true }) then
                return
              end
            else
              cmp.complete()
            end
          end,
        }),

        -- ["<tab>"] = false,
        ["<tab>"] = cmp.config.disable,

        -- Testing
        ["<c-q>"] = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        }),
      }),
      -- TODO: Investigate if this is actually making things better or worse
      -- NOTE: Copied from TJ
      ---@diagnostic disable-next-line: missing-fields
      sorting = {
        -- comparators = {
        --   cmp.config.compare.offset,
        --   cmp.config.compare.exact,
        --   cmp.config.compare.score,
        --
        --   -- copied from cmp-under, but I don't think I need the plugin for this.
        --   -- I might add some more of my own.
        --   function(entry1, entry2)
        --     local _, entry1_under = entry1.completion_item.label:find("^_+")
        --     local _, entry2_under = entry2.completion_item.label:find("^_+")
        --     entry1_under = entry1_under or 0
        --     entry2_under = entry2_under or 0
        --     if entry1_under > entry2_under then
        --       return false
        --     elseif entry1_under < entry2_under then
        --       return true
        --     end
        --   end,
        --
        --   cmp.config.compare.kind,
        --   cmp.config.compare.sort_text,
        --   cmp.config.compare.length,
        --   cmp.config.compare.order,
        -- },
      },
      -- REVIEW: Should all alternatives still be returned though lspkind? It seems to me as if it doesn't overwrite values?
      formatting = {
        -- Set order of "columns" (icon | title | source)
        fields = { "kind", "abbr", "menu" },
        expandable_indicator = true,
        format = function(entry, vim_item)
          local MENU_MAPPER = {
            buffer = "Buf",
            nvim_lsp = "LSP",
            nvim_lua = "Nvim-lua",
            path = "Path",
            luasnip = "Snip",
            codeium = "🤖",
            npm = "npm",
          }
          local function getMappedMenu(entry)
            return MENU_MAPPER[entry.source.name] or entry.source.name or "??"
          end

          -- Tailwind colors
          if vim_item.kind == "Color" then
            vim_item = require("cmp-tailwind-colors").format(entry, vim_item)

            if vim_item.kind ~= "Color" then
              vim_item.menu = getMappedMenu(entry)
              return vim_item
            end
          end
          -- Custom kind for custom icon
          if entry.source.name == "npm" then
            vim_item.kind = "npm"
          end
          -- Pathname with file icon
          if vim.tbl_contains({ "path" }, entry.source.name) then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              vim_item.kind = icon
              vim_item.kind_hl_group = hl_group
              vim_item.menu = getMappedMenu(entry)
              return vim_item
            end
          end
          -- Lspkind (e.g. variable + icon) for remaining
          return lspkind.cmp_format({
            mode = "symbol",
            maxwidth = 50,
            ellipsis_char = "...",
            menu = MENU_MAPPER,
            symbol_map = {
              npm = "",
            },
          })(entry, vim_item)
        end,
      },
    })

    -- `:` cmdline setup.
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
        {
          -- Adding this to use with Octo.nvim
          name = "git",
        },
      }, {
        {
          name = "cmdline",
          option = {
            -- Default
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })

    -- `/` cmdline setup.
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- git completion setup
    require("cmp_git").setup()
  end,
}
