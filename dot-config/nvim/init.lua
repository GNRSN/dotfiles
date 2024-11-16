if vim.g.vscode then
  -- VSCode extension
  require("vscode-nvim")
else
  -- Hide virtual text
  vim.diagnostic.config({
    -- virtual_text = false,
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
  })

  -- Delay notifications until noice.nvim is online
  require("util").lazy_notify()

  pcall(function()
    require("colorscheme").setup({
      transparent_bg = true,
    })
    require("colorscheme").load()
  end)

  if require("neovide").ctx_is_neovide() then
    require("neovide").setup()
  end

  require("config").setup()
end
