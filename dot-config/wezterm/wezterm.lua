local wez = require("wezterm")
local config = wez.config_builder()

-- LATER: Configure $TERM as wezterm, this indicate that wezterm capabilities are available for some programs,
-- required installing wezterm term definitions
--
-- config.term = "wezterm"

-- ===
-- Font
-- ===
config.font = wez.font_with_fallback({
  "Hack Nerd Font Mono",
  {
    -- Use apple emojis instead of Wezterm builtin
    family = "Apple Color Emoji",
  },
})

config.font_size = 14
config.underline_thickness = "1pt"

-- DOC: Control whether changing the font size adjusts the dimensions of the window (true)
-- or adjusts the number of terminal rows/columns (false). The default is true.
-- If you use a tiling window manager then you may wish to set this to false.
config.adjust_window_size_when_changing_font_size = false

config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"

-- ===
-- Cursor
-- ===
-- NOTE: From what I understand, this actually overrides the default block style, so setting this to anything else
-- then BlinkingBlock makes us unable to achieve BlinkingBlock at all
-- TODO: I think I want to fix this so that line is the default
config.default_cursor_style = "BlinkingBlock"
-- IMO better scaling on macbook display since it accounts for window dpi
config.cursor_thickness = "1pt"

-- ===
-- Colors
-- ===
config.color_scheme = "Dark+"
config.window_background_opacity = 0.60
config.macos_window_background_blur = 44

config.colors = {
  background = "#111",
  cursor_bg = "#FF79C6",
  cursor_border = "#FF79C6",
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

-- ===
-- Notifications
-- ===

config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = "EaseIn",
  fade_in_duration_ms = 150,
  fade_out_function = "EaseOut",
  fade_out_duration_ms = 150,
}

config.colors.visual_bell = "#202020"

-- ===
-- Misc
-- ===

-- This makes wezterm feel a lot snappier
config.max_fps = 120

config.animation_fps = 30

config.scrollback_lines = 9999
config.enable_scroll_bar = true

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

function process_basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function is_zsh(pane)
  local process_name = process_basename(pane:get_foreground_process_name())
  wez.log_info("process_name: " .. process_name)
  return process_name == "zsh"
end

---@param opts {key: string, mods?: string, condition: function, action_spec: table}
local function conditional_action(opts)
  return {
    key = opts.key,
    mods = opts.mods,
    action = wez.action_callback(function(win, pane)
      if opts.condition(pane) then
        win:perform_action(opts.action_spec, pane)
      else
        win:perform_action({
          SendKey = {
            key = opts.key,
            mods = opts.mods,
          },
        }, pane)
      end
    end),
  }
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

-- ===
-- Keybinds
-- ===
local act = wez.action
config.disable_default_key_bindings = true
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1500 }

config.keys = {
  { -- Split pane horizontally
    key = "d",
    mods = "CMD",
    action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
  },
  { -- Split pane vertically
    key = "D",
    mods = "CMD",
    action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
  },
  { -- Close pane
    key = "w",
    mods = "CMD",
    action = act.CloseCurrentPane({ confirm = true }),
  },
  { -- Activate copy mode or vim mode
    key = "Enter",
    mods = "LEADER",
    action = act.ActivateCopyMode,
  },
  { -- Open command palette
    key = "p",
    mods = "CMD",
    action = act.ActivateCommandPalette,
  },
  { -- Maximize pane
    key = "m",
    mods = "CMD",
    action = act.TogglePaneZoomState,
  },
  conditional_action({
    key = "u",
    mods = "CTRL",
    condition = is_zsh,
    action_spec = {
      ScrollByPage = -0.3,
    },
  }),
  conditional_action({
    key = "d",
    mods = "CTRL",
    condition = is_zsh,
    action_spec = {
      ScrollByPage = 0.3,
    },
  }),
  { -- Clear scrollback
    key = "l",
    mods = "CMD",
    action = act.ClearScrollback("ScrollbackAndViewport"),
  },
  -- ===
  -- Control font size
  -- ===
  {
    key = "+",
    mods = "CMD",
    action = act.IncreaseFontSize,
  },
  {
    key = "-",
    mods = "CMD",
    action = act.DecreaseFontSize,
  },
  {
    key = "0",
    mods = "CMD",
    action = act.ResetFontSize,
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
    action = act.MoveTabRelative(-1),
  },
  {
    key = "RightArrow",
    mods = "CMD|OPT",
    action = act.MoveTabRelative(1),
  },

  -- DEFAULT KEYBINDS
  { key = "Enter", mods = "LEADER", action = act.ActivateCopyMode },
  { key = "1", mods = "SUPER", action = act.ActivateTab(0) },
  { key = "2", mods = "SUPER", action = act.ActivateTab(1) },
  { key = "3", mods = "SUPER", action = act.ActivateTab(2) },
  { key = "4", mods = "SUPER", action = act.ActivateTab(3) },
  { key = "5", mods = "SUPER", action = act.ActivateTab(4) },
  { key = "6", mods = "SUPER", action = act.ActivateTab(5) },
  { key = "7", mods = "SUPER", action = act.ActivateTab(6) },
  { key = "8", mods = "SUPER", action = act.ActivateTab(7) },
  { key = "9", mods = "SUPER", action = act.ActivateTab(-1) },
  { key = "C", mods = "CTRL", action = act.CopyTo("Clipboard") },
  { key = "C", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "D", mods = "SUPER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  { key = "F", mods = "CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "F", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
  -- { key = "H", mods = "CTRL", action = act.HideApplication },
  -- { key = "H", mods = "SHIFT|CTRL", action = act.HideApplication },
  { key = "K", mods = "CTRL", action = act.ClearScrollback("ScrollbackOnly") },
  { key = "K", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
  { key = "L", mods = "CTRL", action = act.ShowDebugOverlay },
  { key = "L", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
  { key = "M", mods = "CTRL", action = act.Hide },
  { key = "M", mods = "SHIFT|CTRL", action = act.Hide },
  { key = "N", mods = "CTRL", action = act.SpawnWindow },
  { key = "N", mods = "SHIFT|CTRL", action = act.SpawnWindow },
  { key = "P", mods = "CTRL", action = act.ActivateCommandPalette },
  { key = "P", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
  { key = "Q", mods = "CTRL", action = act.QuitApplication },
  { key = "Q", mods = "SHIFT|CTRL", action = act.QuitApplication },
  { key = "R", mods = "CTRL", action = act.ReloadConfiguration },
  { key = "R", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
  { key = "T", mods = "CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "T", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "U",
    mods = "CTRL",
    action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
  },
  {
    key = "U",
    mods = "SHIFT|CTRL",
    action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
  },
  { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") },
  { key = "V", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  { key = "W", mods = "CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "W", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "X", mods = "CTRL", action = act.ActivateCopyMode },
  { key = "X", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
  { key = "Z", mods = "CTRL", action = act.TogglePaneZoomState },
  { key = "Z", mods = "SHIFT|CTRL", action = act.TogglePaneZoomState },
  { key = "[", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(-1) },
  { key = "]", mods = "SHIFT|SUPER", action = act.ActivateTabRelative(1) },
  { key = "^", mods = "CTRL", action = act.ActivateTab(5) },
  { key = "^", mods = "SHIFT|CTRL", action = act.ActivateTab(5) },
  { key = "c", mods = "SHIFT|CTRL", action = act.CopyTo("Clipboard") },
  { key = "c", mods = "SUPER", action = act.CopyTo("Clipboard") },
  { key = "d", mods = "SUPER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "f", mods = "SHIFT|CTRL", action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "f", mods = "SUPER", action = act.Search("CurrentSelectionOrEmptyString") },
  -- { key = "h", mods = "ALT", action = act.EmitEvent("user-defined-4") },
  -- { key = "h", mods = "CTRL", action = act.EmitEvent("user-defined-0") },
  { key = "h", mods = "SHIFT|CTRL", action = act.HideApplication },
  { key = "h", mods = "SUPER", action = act.HideApplication },
  -- { key = "j", mods = "ALT", action = act.EmitEvent("user-defined-5") },
  -- { key = "j", mods = "CTRL", action = act.EmitEvent("user-defined-1") },
  -- { key = "k", mods = "ALT", action = act.EmitEvent("user-defined-6") },
  -- { key = "k", mods = "CTRL", action = act.EmitEvent("user-defined-2") },
  { key = "k", mods = "SHIFT|CTRL", action = act.ClearScrollback("ScrollbackOnly") },
  { key = "k", mods = "SUPER", action = act.ClearScrollback("ScrollbackOnly") },
  -- { key = "l", mods = "ALT", action = act.EmitEvent("user-defined-7") },
  -- { key = "l", mods = "CTRL", action = act.EmitEvent("user-defined-3") },
  { key = "l", mods = "SHIFT|CTRL", action = act.ShowDebugOverlay },
  {
    key = "l",
    mods = "SUPER",
    action = act.Multiple({
      { ClearScrollback = "ScrollbackAndViewport" },
      { SendKey = { key = "l", mods = "CTRL" } },
    }),
  },
  { key = "m", mods = "SHIFT|CTRL", action = act.Hide },
  { key = "m", mods = "SUPER", action = act.TogglePaneZoomState },
  { key = "n", mods = "SHIFT|CTRL", action = act.SpawnWindow },
  { key = "n", mods = "SUPER", action = act.SpawnWindow },
  { key = "p", mods = "SHIFT|CTRL", action = act.ActivateCommandPalette },
  { key = "p", mods = "SUPER", action = act.ActivateCommandPalette },
  { key = "q", mods = "SHIFT|CTRL", action = act.QuitApplication },
  { key = "q", mods = "SUPER", action = act.QuitApplication },
  { key = "r", mods = "SHIFT|CTRL", action = act.ReloadConfiguration },
  { key = "r", mods = "SUPER", action = act.ReloadConfiguration },
  { key = "t", mods = "SHIFT|CTRL", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "t", mods = "SUPER", action = act.SpawnTab("CurrentPaneDomain") },
  {
    key = "u",
    mods = "SHIFT|CTRL",
    action = act.CharSelect({ copy_on_select = true, copy_to = "ClipboardAndPrimarySelection" }),
  },
  { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
  { key = "v", mods = "SUPER", action = act.PasteFrom("Clipboard") },
  { key = "w", mods = "SHIFT|CTRL", action = act.CloseCurrentTab({ confirm = true }) },
  { key = "w", mods = "SUPER", action = act.CloseCurrentPane({ confirm = true }) },
  { key = "x", mods = "SHIFT|CTRL", action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "SHIFT|CTRL", action = act.QuickSelect },
  { key = "LeftArrow", mods = "ALT|SUPER", action = act.MoveTabRelative(-1) },
  { key = "RightArrow", mods = "ALT|SUPER", action = act.MoveTabRelative(1) },
  { key = "Copy", mods = "NONE", action = act.CopyTo("Clipboard") },
  { key = "Paste", mods = "NONE", action = act.PasteFrom("Clipboard") },
}

-- From defaults, i'm not sure if these are removed when `disable_default_key_bindings`
wez.key_tables = {
  copy_mode = {
    { key = "Tab", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    { key = "Tab", mods = "SHIFT", action = act.CopyMode("MoveBackwardWord") },
    { key = "Enter", mods = "NONE", action = act.CopyMode("MoveToStartOfNextLine") },
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    { key = "Space", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "$", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "$", mods = "SHIFT", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = ",", mods = "NONE", action = act.CopyMode("JumpReverse") },
    { key = "0", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = ";", mods = "NONE", action = act.CopyMode("JumpAgain") },
    { key = "F", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = "F", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = false } }) },
    { key = "G", mods = "NONE", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "G", mods = "SHIFT", action = act.CopyMode("MoveToScrollbackBottom") },
    { key = "H", mods = "NONE", action = act.CopyMode("MoveToViewportTop") },
    { key = "H", mods = "SHIFT", action = act.CopyMode("MoveToViewportTop") },
    { key = "L", mods = "NONE", action = act.CopyMode("MoveToViewportBottom") },
    { key = "L", mods = "SHIFT", action = act.CopyMode("MoveToViewportBottom") },
    { key = "M", mods = "NONE", action = act.CopyMode("MoveToViewportMiddle") },
    { key = "M", mods = "SHIFT", action = act.CopyMode("MoveToViewportMiddle") },
    { key = "O", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "O", mods = "SHIFT", action = act.CopyMode("MoveToSelectionOtherEndHoriz") },
    { key = "T", mods = "NONE", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "T", mods = "SHIFT", action = act.CopyMode({ JumpBackward = { prev_char = true } }) },
    { key = "V", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { key = "V", mods = "SHIFT", action = act.CopyMode({ SetSelectionMode = "Line" }) },
    { key = "^", mods = "NONE", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "^", mods = "SHIFT", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "b", mods = "NONE", action = act.CopyMode("MoveBackwardWord") },
    { key = "b", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
    { key = "b", mods = "CTRL", action = act.CopyMode("PageUp") },
    { key = "c", mods = "CTRL", action = act.CopyMode("Close") },
    { key = "d", mods = "CTRL", action = act.CopyMode({ MoveByPage = 0.5 }) },
    { key = "e", mods = "NONE", action = act.CopyMode("MoveForwardWordEnd") },
    { key = "f", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = false } }) },
    { key = "f", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
    { key = "f", mods = "CTRL", action = act.CopyMode("PageDown") },
    { key = "g", mods = "NONE", action = act.CopyMode("MoveToScrollbackTop") },
    { key = "g", mods = "CTRL", action = act.CopyMode("Close") },
    { key = "h", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "j", mods = "NONE", action = act.CopyMode("MoveDown") },
    { key = "k", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "l", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "m", mods = "ALT", action = act.CopyMode("MoveToStartOfLineContent") },
    { key = "o", mods = "NONE", action = act.CopyMode("MoveToSelectionOtherEnd") },
    { key = "q", mods = "NONE", action = act.CopyMode("Close") },
    { key = "t", mods = "NONE", action = act.CopyMode({ JumpForward = { prev_char = true } }) },
    { key = "u", mods = "CTRL", action = act.CopyMode({ MoveByPage = -0.5 }) },
    { key = "v", mods = "NONE", action = act.CopyMode({ SetSelectionMode = "Cell" }) },
    { key = "v", mods = "CTRL", action = act.CopyMode({ SetSelectionMode = "Block" }) },
    { key = "w", mods = "NONE", action = act.CopyMode("MoveForwardWord") },
    {
      key = "y",
      mods = "NONE",
      action = act.Multiple({ { CopyTo = "ClipboardAndPrimarySelection" }, { CopyMode = "Close" } }),
    },
    { key = "PageUp", mods = "NONE", action = act.CopyMode("PageUp") },
    { key = "PageDown", mods = "NONE", action = act.CopyMode("PageDown") },
    { key = "End", mods = "NONE", action = act.CopyMode("MoveToEndOfLineContent") },
    { key = "Home", mods = "NONE", action = act.CopyMode("MoveToStartOfLine") },
    { key = "LeftArrow", mods = "NONE", action = act.CopyMode("MoveLeft") },
    { key = "LeftArrow", mods = "ALT", action = act.CopyMode("MoveBackwardWord") },
    { key = "RightArrow", mods = "NONE", action = act.CopyMode("MoveRight") },
    { key = "RightArrow", mods = "ALT", action = act.CopyMode("MoveForwardWord") },
    { key = "UpArrow", mods = "NONE", action = act.CopyMode("MoveUp") },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode("MoveDown") },
  },

  search_mode = {
    { key = "Enter", mods = "NONE", action = act.CopyMode("PriorMatch") },
    { key = "Escape", mods = "NONE", action = act.CopyMode("Close") },
    { key = "n", mods = "CTRL", action = act.CopyMode("NextMatch") },
    { key = "p", mods = "CTRL", action = act.CopyMode("PriorMatch") },
    { key = "r", mods = "CTRL", action = act.CopyMode("CycleMatchType") },
    { key = "u", mods = "CTRL", action = act.CopyMode("ClearPattern") },
    { key = "PageUp", mods = "NONE", action = act.CopyMode("PriorMatchPage") },
    { key = "PageDown", mods = "NONE", action = act.CopyMode("NextMatchPage") },
    { key = "UpArrow", mods = "NONE", action = act.CopyMode("PriorMatch") },
    { key = "DownArrow", mods = "NONE", action = act.CopyMode("NextMatch") },
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
      { Text = " 🔎   Maximized       " },
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
