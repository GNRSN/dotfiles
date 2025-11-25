---@class DefaultConfig
---@field transparent_bg boolean
local DEFAULT_CONFIG = {
  transparent_bg = false,
}

local function apply_term_colors()
  local palette = require("colorscheme.palette")
  -- NOTE: libvterm used by nvim does't support some escape sequences, e.g. for dimmed text
  -- so there may still be descrepencies to regular terminal
  vim.g.terminal_color_0 = "#000000"
  vim.g.terminal_color_1 = "#cd3131"
  vim.g.terminal_color_2 = "#0dbc79"
  vim.g.terminal_color_3 = "#e5e510"
  vim.g.terminal_color_4 = "#2472c8"
  vim.g.terminal_color_5 = "#bc3fbc"
  vim.g.terminal_color_6 = "#11a8cd"
  vim.g.terminal_color_7 = "#e5e5e5"
  vim.g.terminal_color_8 = "#666666"
  vim.g.terminal_color_9 = "#f14c4c"
  vim.g.terminal_color_10 = "#23d18b"
  vim.g.terminal_color_11 = "#f5f543"
  vim.g.terminal_color_12 = "#3b8eea"
  vim.g.terminal_color_13 = "#d670d6"
  vim.g.terminal_color_14 = "#29b8db"
  vim.g.terminal_color_15 = "#e5e5e5"
  vim.g.terminal_color_foreground = "#cccccc"
  vim.g.terminal_color_background = palette.bg
end

---apply colorscheme
---@param configs DefaultConfig
local function apply(configs)
  local palette = require("colorscheme.palette")
  apply_term_colors()
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
    vim.api.nvim_set_hl(0, group, setting)
  end
end

local local_configs = DEFAULT_CONFIG

local M = {}

---setup colorscheme
---@param configs DefaultConfig?
function M.setup(configs)
  if type(configs) == "table" then
    local_configs = vim.tbl_deep_extend("force", DEFAULT_CONFIG, configs) --[[@as DefaultConfig]]
  end
end

---load colorscheme
function M.load()
  -- reset colors
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end

  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end

  vim.o.background = "dark"
  vim.g.colors_name = "colorscheme"

  apply(local_configs)
end

function M.get_configs()
  return local_configs
end

return M
