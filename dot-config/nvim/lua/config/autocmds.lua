local function augroup(name)
  return vim.api.nvim_create_augroup("gnrsn_" .. name, { clear = true })
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
    "startuptime",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Add custom filetype mappings
for ft, pattern in pairs(require("config.filetype-mappings")) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("map_filetype_(global)_" .. ft),
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
    desc = "Set filetype [" .. ft .. "] from global conf",
  })
end

-- Add custom filetype mappings (from project settings)
-- LATER: Also read vscode/settings.json files.associations field
for ft, pattern in pairs(require("util.local-config").get_workspace_config().filetype_mappings) do
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup("map_filetype_(project)_" .. ft),
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
    desc = "Set filetype [" .. ft .. "] from project conf",
  })
end
