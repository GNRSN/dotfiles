return {
  { -- Makes it easier to work with bullets/numbered lists
    "kaymmm/bullets.nvim",
    -- TODO: Disabled, breaks snacks picker enter to select file keybind
    cond = false,
    -- Default config?
    opts = {
      colon_indent = true,
      delete_last_bullet = true,
      empty_buffers = true,
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
