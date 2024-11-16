local Util = require("util")
local lazygit_graphite = require("util.git-tui").lazygit_graphite

local function map(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys
  -- do not create the keymap if a lazy keys handler exists
  ---@diagnostic disable-next-line: undefined-field
  if not keys.active[keys.parse({ lhs, mode = mode }).id] then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

---------------------
-- General Keymaps
---------------------

-- clear search highlights
map("n", "<leader>uh", ":nohl<CR>", { desc = "clear highlights" })

-- delete single character without copying into register
map("n", "x", "\"_x")

-- increment/decrement numbers
map("n", "<leader>+", "<C-a>", { desc = "increment" })
map("n", "<leader>-", "<C-x>", { desc = "decrement" })

----------------------
-- From Lazyvim
----------------------

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
-- map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
-- map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("i", "<space>", "<space><c-g>u")

-- better indenting
map("v", "<S-tab>", "<gv")
map("v", "<tab>", ">gv")

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- stylua: ignore start

-- toggle options
-- map("n", "<leader>uf", require("plugins.lsp.format").toggle, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function() Util.toggle_diagnostics() end, { desc = "Toggle Diagnostics" })

local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 2
map("n", "<leader>uC", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })

-- lazygit
map("n", "<leader>gg", require('util.git-tui').utils.lazygit_smart_open, { desc = "Lazygit (root dir)" })
map("n", "<leader>gr", function() lazygit_graphite:toggle() end, { desc = "Lazygit with Graphite config (root dir)" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- Scandinavian keyboard compensation
-- I experienced $ including the eol/newline in selections so stepping back and forth got rid of that
map({ "n", "x", "o" }, "€", "$hl", { desc = "End of line"})
map({ "n", "x", "o" }, "ö", "[", { desc = "["})
map({ "n", "x", "o" }, "ä", "]", { desc = "]"})

-- Unmap K in visual mode to avoid annoying message if fumbled
map({ "v" }, "K", "<nop>", { silent = true })
-- Create a buffler local mapping in help docs for gd to keywordprg
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "help" },
  callback = function()
    -- K maps to keywordprg in this filetype
    vim.keymap.set("n", "gd", "K", { buffer = 0 })
  end,
})

-- Unbind command history because I often fumble this
map({ "n", "x", "o" }, "q:", "<nop>")

-- Closer eagle hover on esc, might mess with other buffers?
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "nofile" and vim.bo.filetype == "markdown" then
      vim.api.nvim_buf_set_keymap(0, "n", "<esc>", ":q<CR>", { noremap = true, silent = true })
    end
  end,
})

-- Search with visual selection
map("x", "/", "y/\\V<C-R>=escape(@\",'/\\')<CR><CR>", { desc = "Search for selection" })
