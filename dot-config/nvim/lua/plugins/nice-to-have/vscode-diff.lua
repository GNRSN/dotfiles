return {
  { -- Upgraded "diffview" with custom lib/binary emulating vscode diffing algorithm
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = {
      "CodeDiff",
    },
  },
}
