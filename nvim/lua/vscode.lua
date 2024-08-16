print("Neovim: VScode specific config")

local remap = vim.api.nvim_set_keymap

-- We need to overwrite the default keymap which defaults to <next>
remap("", "<SPACE>", "<Nop>", { noremap = false })

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------
-- VScode specific keymaps --
-----------------------------

-- Search
remap(
	"n",
	"<leader><leader>",
	"<Cmd>call VSCodeNotify('workbench.action.quickOpen')<CR>",
	{ noremap = true, desc = "Open file search" }
)

remap(
	"n",
	"<leader>fs",
	"<Cmd>call VSCodeNotify('workbench.view.search')<CR>",
	{ noremap = true, desc = "Open text search" }
)

-- File explorer

remap(
	"n",
	"<leader>e",
	"<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>",
	{ noremap = true, desc = "Open file exporer" }
)

-- Close handled through VScode cause I could not figure out how to toggle from here
-- remap(
-- 	"n",
-- 	"<leader>e",
-- 	"<Cmd>call VSCodeNotify('workbench.action.closeSidebar')<CR>",
-- 	{ noremap = true, desc = "Toggle file exporer" }
-- )

-- Terminal
remap(
	"n",
	"<leader>t",
	"<Cmd>call VSCodeNotify('workbench.action.togglePanel')<CR>",
	{ noremap = true, desc = "Open terminal" }
)

-- Lazygit
remap(
	"n",
	"<leader>gg",
	"<Cmd>call VSCodeNotify('workbench.action.tasks.runTask', 'close_lazygit')<CR>",
	{ noremap = true, desc = "Open lazygit" }
)

-- Quickfix
remap(
	"n",
	"<leader>ca",
	"<Cmd>call VSCodeNotify('editor.action.quickFix')<CR>",
	{ noremap = true, desc = "Open quickfix" }
)

remap("n", "<leader>cr", "<Cmd>call VSCodeNotify('editor.action.rename')<CR>", { noremap = true, desc = "Open rename" })

-- I likely have to disable the default mapping?
-- remap(
-- 	"n",
-- 	"<S-k>",
-- 	"<Cmd>call VSCodeNotify('editor.actions.showOrFocusHover', { focus: true })<CR>",
-- 	{ noremap = true, desc = "Open details" }
-- )

-- Diagnostics
remap(
	"n",
	"<leader>xx",
	"<Cmd>call VSCodeNotify('workbench.actions.view.problems')<CR>",
	{ noremap = true, desc = "Open diagnostics" }
)

remap(
	"n",
	"<leader>xn",
	"<Cmd>call VSCodeNotify('editor.action.marker.nextInFiles')<CR>",
	{ noremap = true, desc = "Jump to next warning/error" }
)

remap(
	"n",
	"<leader>xp",
	"<Cmd>call VSCodeNotify('editor.action.marker.prevInFiles')<CR>",
	{ noremap = true, desc = "Jump to previous warning/error" }
)

-- Split
remap(
	"n",
	"<leader>Sv",
	"<Cmd>call VSCodeNotify('workbench.action.splitEditor')<CR>",
	{ noremap = true, desc = "Vertical split" }
)

-- Harpoon

remap(
	"n",
	"<leader>hm",
	"<Cmd>call VSCodeNotify('vscode-harpoon.addEditor')<CR>",
	{ noremap = true, desc = "Harpoon: Mark file" }
)

remap(
	"n",
	"<leader>hl",
	"<Cmd>call VSCodeNotify('vscode-harpoon.editEditors')<CR>",
	{ noremap = true, desc = "Harpoon: Edit" }
)

remap(
	"n",
	"<leader>hq",
	"<Cmd>call VSCodeNotify('vscode-harpoon.editorQuickPick')<CR>",
	{ noremap = true, desc = "Harpoon: Quick pick" }
)

remap(
	"n",
	"<leader>1",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor1')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 1" }
)

remap(
	"n",
	"<leader>2",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor2')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 2" }
)

remap(
	"n",
	"<leader>3",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor3')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 3" }
)

remap(
	"n",
	"<leader>4",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor4')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 4" }
)

remap(
	"n",
	"<leader>5",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor5')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 5" }
)

remap(
	"n",
	"<leader>6",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor6')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 6" }
)

remap(
	"n",
	"<leader>7",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor7')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 7" }
)

remap(
	"n",
	"<leader>8",
	"<Cmd>call VSCodeNotify('vscode-harpoon.gotoEditor8')<CR>",
	{ noremap = true, desc = "Harpoon: Editor 8" }
)
