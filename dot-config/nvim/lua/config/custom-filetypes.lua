vim.filetype.add({
  filename = {
    ["turbo.json"] = "jsonc",
    [".prettierignore"] = "gitignore",
    [".worktreeinclude"] = "gitignore",
    ["config"] = function(path, bufnr)
      if path:match("/git/config$") then
        return "gitconfig"
      end
      return "conf"
    end,
  },
  extension = {
    -- No mdx treesitter grammar available
    ---@see https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
    ---@see https://www.in2deep.xyz/posts/astro-development-using-nvim/
    ["mdx"] = "markdown.mdx",
    ["applescript"] = "applescript",
    ["osascript"] = "osascript",
  },
})

-- Map Bun shebang to typescript filetype
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = vim.api.nvim_create_augroup("bun_shebang_ft", { clear = true }),
  callback = function(args)
    local first = vim.api.nvim_buf_get_lines(args.buf, 0, 1, false)[1] or ""
    if first:match("^#!.*%f[%a]bun%f[%A]") then
      vim.bo[args.buf].filetype = "typescript"
    end
  end,
})
