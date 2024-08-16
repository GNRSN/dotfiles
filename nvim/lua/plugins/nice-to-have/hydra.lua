local window_menu = [[

  ^^^^^^     Move     ^^^^^^   ^^    Size   ^^   ^^     Split       
  ^^^^^^--------------^^^^^^   ^^-----------^^   ^^---------------  
  ^ ^ _k_ ^ ^   ^ ^ _K_ ^ ^     ^    _+_   ^     _s_: Horizontally  
  _h_ ^ ^ _l_   _H_ ^ ^ _L_        _<_ _>_       _v_: Vertically
  ^ ^ _j_ ^ ^   ^ ^ _J_ ^ ^     ^    _-_   ^     _c_: Close
  focus^^^^^^   window^^^^^^   ^ _=_ equalize^   _o_: Only
                                 ^^^^^^^^^^^^^^^^_m_: Maximize

           ^^^^shift _<C-e>_^^^^  ^^^^swap _<C-w>_^^^^

]]

local function cmd(command)
  return table.concat({ "<Cmd>", command, "<CR>" })
end

return {
  -- Nvim implementation of emacs hydra, define chained inputs which allow repetition without repeating the head of the chain
  {
    "anuvyklack/hydra.nvim",
    dependencies = {
      {
        -- Better options for moving splits
        "sindrets/winshift.nvim",
        config = true,
      },
      "anuvyklack/windows.nvim",
    },
    config = function()
      local Hydra = require("hydra")

      -- Resize window
      -- See https://github.com/anuvyklack/hydra.nvim/wiki/Windows-and-buffers-management for detailed example
      Hydra({
        name = "Resize window",
        hint = window_menu,
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            position = "middle",
            border = "rounded",
          },
        },
        mode = "n",
        body = "<C-w>",
        heads = {
          -- split windows
          { "s", cmd("split") },
          { "v", cmd("vsplit") },

          { "c", cmd("close") }, -- close current window
          { "o", cmd("only") }, -- close all windows but current

          -- window resizing
          { "=", cmd("WindowsEqualize") },
          { "+", cmd("wincmd +") },
          { "-", cmd("wincmd -") },
          { "<", cmd("wincmd <") },
          { ">", cmd("wincmd >") },

          -- focus window
          { "h", cmd("wincmd h") },
          { "j", cmd("wincmd j") },
          { "k", cmd("wincmd k") },
          { "l", cmd("wincmd l") },
          -- { "f", focus_window },

          -- Zoom windows
          { "m", cmd("WindowsMaximize") },

          -- move window around
          { "H", cmd("WinShift left") },
          { "J", cmd("WinShift down") },
          { "K", cmd("WinShift up") },
          { "L", cmd("WinShift right") },

          -- WinShift modes
          { "<C-w>", cmd("WinShift swap") },
          { "<C-e>", cmd("WinShift") },

          { "q", nil, { exit = true, desc = false } },
          { "<CR>", nil, { exit = true, desc = false } },
          { "<Esc>", nil, { exit = true, desc = false } },
        },
      })

      -- LATER: Add hydra for stepping next/prev with [/]
    end,
  },
}
