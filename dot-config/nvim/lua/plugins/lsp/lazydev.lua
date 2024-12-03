return {
  -- Successor of neodev, configures lua lsp in nvim directory to know of nvim globals + plugins
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        "lazy.nvim",
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
        { path = "wezterm-types", mods = { "wezterm" } },
        { path = "snacks.nvim", words = { "Snacks%.", "snacks%." } },
      },
    },
  },
  -- Optional types, loaded as needed
  { "Bilal2453/luvit-meta", lazy = true },
  { "justinsgithub/wezterm-types", lazy = true },
}
