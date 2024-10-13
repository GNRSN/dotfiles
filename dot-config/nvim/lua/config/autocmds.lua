local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, "\"")
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "qf",
    "help",
    "man",
    "notify",
    "lspinfo",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Format on save
local format_on_save = require("util.format-on-save")

-- Add commands to enable/disable format on save
vim.api.nvim_create_user_command("FormatOnSaveEnable", format_on_save.enable, {
  desc = "Enable format-on-save",
})
vim.api.nvim_create_user_command("FormatOnSaveDisable", format_on_save.disable, {
  desc = "Disable format-on-save",
})
vim.api.nvim_create_user_command("FormatOnSaveToggle", format_on_save.toggle, {
  desc = "Toggle format-on-save",
})

vim.api.nvim_create_user_command("FormatOnSaveInit", format_on_save.init, {
  desc = "Toggle format-on-save",
})
