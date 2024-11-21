return {
  { -- Better spellcheck,
    -- re-uses vim's native spellchecking but handles camelCase/snake_case, etc
    -- nvim integration was outdated so added custom handler to open in vim.ui.select
    -- NOTE: Some users complained about performance but from what I've seen this is better
    -- than other spellcheckers I have tried
    "kamykn/spelunker.vim",
    config = function()
      -- Custom highlights/underlines
      vim.cmd("highlight SpelunkerSpellBad cterm=undercurl ctermfg=247 gui=undercurl guifg=NONE guisp=#95c698")

      -- Disabling complex word highlighting doesn't seem to work so had to "mask" it by removing all visuals
      vim.cmd("highlight SpelunkerComplexOrCompoundWord cterm=NONE ctermfg=NONE gui=NONE guifg=NONE guisp=NONE")

      -- Dynamic parsing instead of entire buffer on load
      vim.g.spelunker_check_type = 2

      -- Only highlight errors
      vim.g.spelunker_highlight_type = 2

      -- Disable the popup menu plugin
      vim.g.loaded_popup_menu_plugin = 0

      -- === Mimic spelunker's [fix word] but with nvim ui ===

      -- Create our custom suggestion handler
      _G.spelunker_suggest_handler = function(is_correct_all)
        local word = vim.fn.expand("<cword>")

        -- Get suggestions using vim's native spell suggest
        local suggestions = vim.fn.spellsuggest(word)

        if #suggestions == 0 then
          vim.notify("No suggestions available", vim.log.levels.INFO)
          return
        end

        vim.ui.select(suggestions, {
          prompt = "Spell Suggestions for: " .. word,
          format_item = function(item)
            return item
          end,
        }, function(selected)
          if selected then
            if is_correct_all then
              -- Replace all occurrences
              local cmd = string.format("%%s/\\<%s\\>/%s/g", word, selected)
              vim.cmd(cmd)
            else
              -- Replace just this occurrence
              vim.cmd(string.format("normal! ciw%s", selected))
            end
          end
        end)
      end

      -- Set up the keymaps after VimEnter to ensure plugin is loaded
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          -- First run spelunker's check
          vim.fn["spelunker#check"]()

          -- Then set up our keymaps
          vim.keymap.set("n", "cs", function()
            vim.fn["spelunker#check_displayed_words"]()
            _G.spelunker_suggest_handler(false)
          end, { noremap = true, desc = "Spell Checker: Fix word" })

          vim.keymap.set("n", "cS", function()
            vim.fn["spelunker#check_displayed_words"]()
            _G.spelunker_suggest_handler(true)
          end, { noremap = true, desc = "Spell Checker: Fix all" })
        end,
      })
    end,
  },
}
