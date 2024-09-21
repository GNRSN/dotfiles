local configs = require("colorscheme").configs()
local palette = require("colorscheme.palette")

local function getBg()
  if configs.transparent_bg then
    return nil
  end

  return palette.bg or configs.lualine_bg_color or palette.black
end

local bg = getBg()

local normal = {
  a = { fg = palette.bg, bg = palette.white, gui = "bold" },
  b = { fg = palette.white, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

local command = {
  a = { fg = palette.bg, bg = palette.yellow_sunflower, gui = "bold" },
  b = { fg = palette.yellow_sunflower, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

local visual = {
  a = { fg = palette.black, bg = palette.green, gui = "bold" },
  b = { fg = palette.green, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

local inactive = {
  a = { fg = palette.white, bg = palette.visual_bg, gui = "bold" },
  b = { fg = palette.fade, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

local replace = {
  a = { fg = palette.black, bg = palette.orange, gui = "bold" },
  b = { fg = palette.orange, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

local insert = {
  a = { fg = palette.black, bg = palette.blue, gui = "bold" },
  b = { fg = palette.blue, bg = bg },
  c = { fg = palette.fg, bg = bg },
  x = { fg = palette.white, bg = bg },
  y = { fg = palette.white, bg = bg },
  z = { fg = palette.white, bg = bg },
}

return {
  normal = normal,
  command = command,
  visual = visual,
  inactive = inactive,
  replace = replace,
  insert = insert,
}
