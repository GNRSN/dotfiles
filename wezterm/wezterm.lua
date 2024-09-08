local wez = require("wezterm")
local config = wez.config_builder()

-- config.term = "wezterm"

-- Font
config.font = wez.font_with_fallback({
  "Hack Nerd Font Mono",
  {
    -- Use apple emojis instead of wezterm builtin
    family = "Apple Color Emoji",
  },
})

-- Cursor
-- NOTE: From what I understand, this actually overrides the default block style, so setting this to anything else
-- then BlinkingBlock makes us unable to achieve BlinkingBlock at all
config.default_cursor_style = "BlinkingBlock"
-- IMO better scaling on macbook display since it accounts for window dpi
config.cursor_thickness = "1pt"

-- Colors
config.color_scheme = "Dark+"
config.window_background_opacity = 0.60
config.macos_window_background_blur = 44

config.colors = {
  background = "#111",
  -- cursor_fg = "pink",
  cursor_bg = "#FF79C6",
}

config.command_palette_bg_color = "#222"

config.window_frame = {
  active_titlebar_bg = "#333333",
  -- When window is not in focus
  inactive_titlebar_bg = "#555555",
}

config.inactive_pane_hsb = {
  saturation = 0.85,
  brightness = 0.35,
}

-- Merges tab-bar and macos window-bar into one thin bar
config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"
-- On nightly:
-- config.show_close_tab_button_in_tabs = false
config.show_new_tab_button_in_tab_bar = false

-- === Misc ===

-- Fix issues with Swedish keyboard
-- https://www.reddit.com/r/wezterm/comments/1bdmufm/cant_write_out_curly_brackets_in_wezterm/
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- === Neovim integration ===

-- if you are *NOT* lazy-loading smart-splits.nvim (recommended)
local function is_vim(pane)
  -- this is set by the plugin, and unset on ExitPre in Neovim
  return pane:get_user_vars().IS_NVIM == "true"
end

local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function split_nav(resize_or_move, key)
  return {
    key = key,
    mods = resize_or_move == "resize" and "META" or "CTRL",
    action = wez.action_callback(function(win, pane)
      if is_vim(pane) then
        -- pass the keys through to vim/nvim
        win:perform_action({
          SendKey = { key = key, mods = resize_or_move == "resize" and "META|CMD" or "CTRL" },
        }, pane)
      else
        if resize_or_move == "resize" then
          win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
        else
          win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
        end
      end
    end),
  }
end

-- Keybindings
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

config.keys = {
  {
    key = "d",
    mods = "CMD",
    action = wez.action.SplitHorizontal({}),
  },
  {
    key = "D",
    mods = "CMD",
    action = wez.action.SplitVertical({}),
  },
  {
    key = "w",
    mods = "CMD",
    action = wez.action.CloseCurrentPane({ confirm = true }),
  },
  { -- Maximize pane
    mods = "LEADER",
    key = "m",
    action = wez.action.TogglePaneZoomState,
  },
  { -- Activate copy mode or vim mode
    key = "Enter",
    mods = "LEADER",
    action = wez.action.ActivateCopyMode,
  },
  {
    key = "p",
    mods = "CMD",
    action = wez.action.ActivateCommandPalette,
  },
  {
    key = "m",
    mods = "CMD",
    action = wez.action.TogglePaneZoomState,
  },
  {
    key = "l",
    mods = "CMD",
    action = wez.action.Multiple({
      wez.action.ClearScrollback("ScrollbackAndViewport"),
      wez.action.SendKey({ key = "l", mods = "CTRL" }),
    }),
  },
  -- move between split panes
  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  -- resize panes
  split_nav("resize", "h"),
  split_nav("resize", "j"),
  split_nav("resize", "k"),
  split_nav("resize", "l"),
  -- Tabs
  {
    key = "LeftArrow",
    mods = "CMD|OPT",
    action = wez.action.MoveTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = "CMD|OPT",
    action = wez.action.MoveTabRelative(1),
  },
}

-- Show pane zoomed status in upper right corner
wez.on("update-status", function(window, pane)
  local our_tab = pane:tab()
  local is_zoomed = false
  if our_tab ~= nil then
    for _, pane_attributes in pairs(our_tab:panes_with_info()) do
      is_zoomed = pane_attributes["is_zoomed"] or is_zoomed
    end
  end
  if is_zoomed then
    window:set_right_status(wez.format({
      { Attribute = { Underline = "Single" } },
      { Attribute = { Italic = true } },
      { Background = { Color = "hsla(0, 0, 0, .05)" } },
      { Foreground = { Color = "yellow" } },
      { Text = " 🔎   Zoomed       " },
    }))
    -- the below assumes you have written a handler that forces tabs to be open
    -- I do this aggressively to force my UI to remind me that I am zoomed
    wez.emit("force-tabs-shown", window, pane)
  else
    window:set_right_status("")
  end

  --- whatever else you want to do with your update-status
end)

return config
