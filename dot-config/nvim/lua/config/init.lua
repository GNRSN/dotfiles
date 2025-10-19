return {
  setup = function()
    -- load options here, before lazy init while sourcing plugin modules
    -- this is needed to make sure options will be correctly applied
    -- after installing missing plugins
    -- DOC: Make sure to setup `mapleader` and `maplocalleader` before
    -- loading lazy.nvim so that mappings are correct.
    -- This is also a good place to setup other settings (vim.opt)
    require("config.options")
    _G.CMP = require("config.CMP")
    require("config.lazy")
    require("config.autocmds")
    require("config.usercmds")
    require("config.keymaps")
  end,
}
