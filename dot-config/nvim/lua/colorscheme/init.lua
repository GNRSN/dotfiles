local o = vim.o
local g = vim.g
local cmd = vim.cmd
local nvim_set_hl = vim.api.nvim_set_hl
local tbl_deep_extend = vim.tbl_deep_extend

---@class DefaultConfig
---@field transparent_bg boolean

local DEFAULT_CONFIG = {
  transparent_bg = false,
}

local function apply_term_colors()
  local palette = require("colorscheme.palette")
  g.terminal_color_0 = palette.black
  g.terminal_color_1 = palette.red
  g.terminal_color_2 = palette.green
  g.terminal_color_3 = palette.yellow
  g.terminal_color_4 = palette.purple
  g.terminal_color_5 = palette.pink
  g.terminal_color_6 = palette.cyan
  g.terminal_color_7 = palette.white
  g.terminal_color_8 = palette.fade
  g.terminal_color_9 = palette.bright_red
  g.terminal_color_10 = palette.bright_green
  g.terminal_color_11 = palette.bright_yellow
  g.terminal_color_12 = palette.bright_blue
  g.terminal_color_13 = palette.bright_magenta
  g.terminal_color_14 = palette.bright_cyan
  g.terminal_color_15 = palette.bright_white
  g.terminal_color_background = palette.bg
  g.terminal_color_foreground = palette.fg
end

---apply colorscheme
---@param configs DefaultConfig
local function apply(configs)
  local palette = require("colorscheme.palette")
  apply_term_colors(palette)
  local hl_groups = require("colorscheme.highlight-groups").setup()

  -- apply transparency
  if configs.transparent_bg then
    local HL_GROUPS_EFFECTED_BY_TRANSPARENCY =
      require("colorscheme.highlight-groups").HL_GROUPS_EFFECTED_BY_TRANSPARENCY

    for _, group_name in ipairs(HL_GROUPS_EFFECTED_BY_TRANSPARENCY) do
      -- Guard against group being commented out
      if hl_groups[group_name] then
        -- Neovim only supports colored or fully transparent background, nil => fully transparent => same as terminal
        -- LATER: Account for neovide which may support blends?
        hl_groups[group_name].bg = nil
      end
    end
  end

  -- set defined highlights
  for group, setting in pairs(hl_groups) do
    nvim_set_hl(0, group, setting)
  end
end

local local_configs = DEFAULT_CONFIG

---setup colorscheme
---@param configs DefaultConfig?
local function setup(configs)
  if type(configs) == "table" then
    local_configs = tbl_deep_extend("force", DEFAULT_CONFIG, configs) --[[@as DefaultConfig]]
  end
end

---load colorscheme
local function load()
  -- reset colors
  if g.colors_name then
    cmd("hi clear")
  end

  if vim.fn.exists("syntax_on") then
    cmd("syntax reset")
  end

  o.background = "dark"
  o.termguicolors = true
  g.colors_name = "colorscheme"

  apply(local_configs)
end

return {
  load = load,
  setup = setup,
  configs = function()
    return local_configs
  end,
}
