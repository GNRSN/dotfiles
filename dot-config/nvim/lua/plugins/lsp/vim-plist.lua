return {
  -- Support .plist binary files
  {
    "darfink/vim-plist",
    -- REVIEW: Doesn't work when lazy loaded
    -- ft = { "plist" },
    init = function()
      -- REVIEW: Should support json but I didn't get it to work
      vim.g.plist_display_format = "xml"
    end,
  },
}
