return {
  { -- Makes it easier to work with bullets/numbered lists
    "kaymmm/bullets.nvim",
    -- Default config ish
    opts = {
      colon_indent = true,
      delete_last_bullet = true,
      -- Has to set to false or it interferes with snacks picker
      empty_buffers = false,
      file_types = { "markdown", "text", "gitcommit" },
      line_spacing = 1,
      mappings = true,
      outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std*", "std-", "std+" },
      renumber = true,
      alpha = {
        len = 2,
      },
      checkbox = {
        nest = true,
        markers = " .oOx",
        toggle_partials = true,
      },
    },
  },
}
