local get_noice_mode = function()
  local noice = pcall(require, "noice")

  if not noice then
    return nil
  end

  return {
    -- Displays "recording" when recording macro, maybe other modes as well?
    ---@diagnostic disable-next-line: deprecated, undefined-field
    require("noice").api.statusline.mode.get,
    ---@diagnostic disable-next-line: deprecated, undefined-field
    cond = require("noice").api.statusline.mode.has,
    color = { fg = require("colorscheme.palette").bright_magenta },
  }
end

local function get_visual_multi(mode)
  local result = vim.fn["VMInfos"]()
  -- local current = result.current
  -- local total = result.total
  local ratio = result.ratio
  local patterns = result.patterns
  -- local status = result.status
  return "%#St_InsertMode# "
    .. " MULTI("
    .. mode
    .. ")"
    .. "%#St_lspWarning# 󱩾\""
    .. patterns[1]
    .. "\" "
    .. "%#StText#"
    .. "["
    .. ratio
    .. "]"
end

local format_on_save_indicator = {
  function()
    return ""
  end,
  cond = function()
    local no_write = {
      nowrite = true,
      nofile = true,
      terminal = true,
      prompt = true,
    }

    return vim.bo.filetype and not no_write[vim.bo.buftype]
  end,
  color = function()
    if require("util.format-on-save").get_state() then
      return {
        fg = require("colorscheme.palette").green,
      }
    else
      return {
        fg = require("colorscheme.palette").fade,
      }
    end
  end,

  separator = nil,
}

local diagnostics_segment = {
  "diagnostics",
  sections = { "error", "warn" },
  symbols = {
    error = " ",
    warn = " ",
  },
  diagnostics_color = {
    -- color_error = { fg = colors.red },
    -- color_warn = { fg = colors.yellow },
  },
}

return {
  -- Customizable status line
  {
    "nvim-lualine/lualine.nvim",
    event = "UIEnter",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = require("colorscheme.status-line"),
          component_separators = "|",
          section_separators = "",
          disabled_filetypes = {
            statusline = {
              "neo-tree",
              "spectre_panel",
              "DiffviewFiles",
            },
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = {
            {
              "mode",
              fmt = function(mode)
                if vim.b["visual_multi"] then
                  return get_visual_multi(mode)
                end

                return mode
              end,
            },
          },
          lualine_b = {
            "filename",
            format_on_save_indicator,
            get_noice_mode(),
          },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { diagnostics_segment },
          lualine_z = { "filetype" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { "filename" },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { diagnostics_segment },
          lualine_z = { "filetype" },
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },
}
