local CTX = {}

function CTX.get_is_neovide()
  return (vim.g.neovide and true) or false
end

CTX.is_ghostty = vim.env.TERM_PROGRAM == "ghostty"

CTX.is_wezterm = vim.env.TERM_PROGRAM == "WezTerm"

CTX.is_zellij = vim.env.ZELLIJ == "0"

function CTX.supports_underline_separator()
  return CTX.get_is_neovide() or CTX.is_ghostty
end

return CTX
