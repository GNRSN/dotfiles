return {
  -- Open goto in float
  {
    "rmagatti/goto-preview",
    keys = {
      {
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        desc = "Preview goto definition",
      },
      {
        "gpt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Preview goto type definition",
      },
      {
        "gpi",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        desc = "Preview goto implementation",
      },
      {
        "gpD",
        "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>",
        desc = "Preview goto declaration",
      },
      {
        "gpr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        desc = "Preview goto reference",
      },
      {
        "gpq",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        desc = "Close all preview windows",
      },
    },
    config = function()
      require("goto-preview").setup({})
    end,
  },
}
