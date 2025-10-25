vim.filetype.add({
  filename = {
    ["turbo.json"] = "jsonc",
    [".prettierignore"] = "gitignore",
  },
  extension = {
    -- No mdx treesitter grammar available
    ---@see https://phelipetls.github.io/posts/mdx-syntax-highlight-treesitter-nvim/
    ---@see https://www.in2deep.xyz/posts/astro-development-using-nvim/
    ["mdx"] = "markdown.mdx",
  },
})
