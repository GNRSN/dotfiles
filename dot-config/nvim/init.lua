if vim.g.vscode then
  -- VSCode extension
  require("vscode-nvim")
else
  -- Delay notifications until noice.nvim is online
  require("util").lazy_notify()

  pcall(function()
    require("colorscheme").setup({
      transparent_bg = true,
    })
    require("colorscheme").load()
  end)

  if require("util.ctx").get_is_neovide() then
    require("neovide").setup()
  end

  require("config").setup()
end
