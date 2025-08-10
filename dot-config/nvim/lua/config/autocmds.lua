local function augroup(name)
  return vim.api.nvim_create_augroup("gnrsn_" .. name, { clear = true })
end

--- ===
--- From LazyVim
--- ===

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
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_esc"),
  pattern = {
    "fyler",
    "lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "<esc>", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})

-- Fix conceallevel for json files
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup("json_conceal"),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

--- ===
--- My own autocommands
--- ===

-- Add custom filetype mappings
for ft, pattern in pairs(require("config.filetype-mappings")) do
  -- REVIEW: Possibly changing these between BufReadPre and BufRead may conflict differently with different plugins/lsp,
  -- preferably they would run before any ft dependent code has run
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
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
  vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
    group = augroup("map_filetype_(project)_" .. ft),
    pattern = pattern,
    callback = function()
      vim.bo.filetype = ft
    end,
    desc = "Set filetype [" .. ft .. "] from project conf",
  })
end
