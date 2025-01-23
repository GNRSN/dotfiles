-- NOTE: Originally copy/paste from from vs-code theme
local M = {}

M.HL_GROUPS_EFFECTED_BY_TRANSPARENCY = {
  "Normal",
  "NormalFloat",
  "Pmenu",
  "SignColumn",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "TelescopeNormal",
  "NoiceMini",
}

---@class Highlight
---@field fg string color name or "#RRGGBB"
---@field foreground string same fg, color name or "#RRGGBB"
---@field bg string color name or "#RRGGBB"
---@field background string same bg, color name or "#RRGGBB"
---@field sp string color name or "#RRGGBB"
---@field special string same sg, color name or "#RRGGBB"
---@field blend integer value between 0 and 100
---@field bold boolean
---@field standout boolean
---@field underline boolean
---@field undercurl boolean
---@field underdouble boolean
---@field underdotted boolean
---@field underdashed boolean
---@field strikethrough boolean
---@field italic boolean
---@field reverse boolean
---@field nocombine boolean
---@field link string name of another highlight group to link to, see |:hi-link|.
---@field default string Don't override existing definition |:hi-default|
---@field ctermfg integer Sets foreground of cterm color |highlight-ctermfg|
---@field ctermbg integer Sets background of cterm color |highlight-ctermbg|
---@field cterm table cterm attribute map, like |highlight-args|.

---setup highlight groups
---@return table<string, Highlight>
---@nodiscard
function M.setup()
  local palette = require("colorscheme.palette")
  local endOfBuffer = {
    fg = palette.bg,
  }

  return {
    Normal = { fg = palette.fg, bg = palette.bg },
    NormalFloat = { fg = palette.fg, bg = palette.bg },
    WinSeparator = { fg = palette.selection },
    Comment = { fg = palette.text_ignored },
    Constant = { fg = palette.yellow },
    String = { fg = palette.yellow },
    Character = { fg = palette.green },
    Number = { fg = palette.number_green },
    Boolean = { fg = palette.cyan },
    Float = { fg = palette.fg },
    FloatBorder = { fg = palette.border },
    FloatTitle = { fg = palette.text_ignored },
    Operator = { fg = palette.purple },
    Keyword = { fg = palette.red },
    --Keywords = { fg = colors.cyan },
    --Identifier = { fg = colors.cyan },
    Function = { fg = palette.yellow },
    Statement = { fg = palette.purple },
    Conditional = { fg = palette.purple },
    Repeat = { fg = palette.pink },
    --Label = { fg = colors.cyan },
    Exception = { fg = palette.purple },
    PreProc = { fg = palette.yellow },
    Include = { fg = palette.purple },
    Define = { fg = palette.purple },
    --Title = { fg = colors.cyan },
    Macro = { fg = palette.purple },
    --PreCondit = { fg = colors.cyan },
    Type = { fg = palette.blue_green },
    StorageClass = { fg = palette.pink },
    Structure = { fg = palette.yellow },
    TypeDef = { fg = palette.yellow },
    Special = { fg = palette.blue_green, italic = true },
    SpecialComment = { fg = palette.comment, italic = true },
    Error = { fg = palette.bright_red },
    Todo = { fg = palette.purple, bold = true, italic = true },
    Underlined = { fg = palette.cyan, underline = true },

    NotifyBackground = { bg = palette.black },

    Cursor = { fg = palette.pink, reverse = true },
    CursorLineNr = { fg = palette.fg, bold = true },

    SignColumn = { bg = palette.bg },

    Conceal = { fg = palette.fade },
    CursorColumn = { bg = palette.black },
    CursorLine = { bg = palette.selection },
    ColorColumn = { bg = palette.selection },

    StatusLine = { fg = palette.white, bg = palette.black },
    StatusLineNC = { fg = palette.fade },
    StatusLineTerm = { fg = palette.white, bg = palette.black },
    StatusLineTermNC = { fg = palette.fade },

    Directory = { fg = palette.fg },
    -- Note, used by diff-view
    DiffAdd = { bg = palette.diff_added },
    DiffChange = { fg = palette.orange },
    DiffDelete = { bg = palette.diff_removed },
    DiffText = { fg = palette.fade },

    ErrorMsg = { fg = palette.bright_red },
    VertSplit = { fg = palette.black },
    Folded = { fg = palette.fade },
    FoldColumn = {},
    Search = { fg = palette.bg, bg = palette.bright_green },
    IncSearch = { fg = palette.bg, bg = palette.bright_green },
    LineNr = { fg = palette.fade },
    MatchParen = { bg = palette.cursor_word_blue },
    NonText = { fg = palette.nontext },
    Pmenu = { fg = palette.white, bg = palette.menu },
    PmenuSel = { fg = palette.white, bg = palette.visual_bg },
    PmenuSbar = { bg = palette.bg },
    PmenuThumb = { bg = palette.border },

    Question = { fg = palette.purple },
    QuickFixLine = { fg = palette.black, bg = palette.yellow },
    SpecialKey = { fg = palette.nontext },

    SpellBad = { fg = palette.bright_red, underline = true },
    SpellCap = { fg = palette.yellow },
    SpellLocal = { fg = palette.yellow },
    SpellRare = { fg = palette.yellow },

    TabLine = { fg = palette.fade },
    TabLineSel = { fg = palette.white },
    TabLineFill = { bg = palette.bg },
    Terminal = { fg = palette.white, bg = palette.black },
    Visual = { bg = palette.visual_bg },
    VisualNOS = { fg = palette.visual_bg },
    WarningMsg = { fg = palette.yellow },
    WildMenu = { fg = palette.black, bg = palette.white },

    EndOfBuffer = endOfBuffer,

    DiagnosticUnnecessary = { fg = palette.text_ignored },

    -- TreeSitter
    -- The list of capture-groups can  be found at:
    -- https://github.com/nvim-treesitter/nvim-treesitter/blob/master/CONTRIBUTING.md#parser-configurations
    ["@error"] = { fg = palette.bright_red },
    ["@punctuation.delimiter"] = { fg = palette.fg },
    ["@punctuation.bracket"] = { fg = palette.blue_medium },
    ["@punctuation.special"] = { fg = palette.blue },

    ["@symbol"] = { fg = palette.purple },

    --["@constant.macro"] = { fg = colors.cyan },
    ["@string.regex"] = { fg = palette.red },
    ["@string"] = { fg = palette.orange },
    ["@string.escape"] = { fg = palette.cyan },
    ["@character"] = { fg = palette.yellow },
    ["@number"] = { fg = palette.number_green },
    ["@boolean"] = { fg = palette.blue_medium },
    ["@float"] = { fg = palette.yellow },
    ["@annotation"] = { fg = palette.yellow },
    ["@attribute"] = { fg = palette.cyan },
    ["@namespace"] = { fg = palette.blue_green },

    ["@function.builtin"] = { fg = palette.cyan },
    ["@function"] = { fg = palette.yellow },
    ["@function.macro"] = { fg = palette.yellow },
    ["@parameter"] = { fg = palette.blue_light },
    ["@parameter.reference"] = { fg = palette.blue_light },
    ["@method"] = { fg = palette.yellow },
    ["@field"] = { fg = palette.blue_light },
    ["@property"] = { fg = palette.blue_light },
    ["@constructor"] = { fg = palette.blue_green },

    ["@conditional.ternary"] = { fg = palette.bright_yellow },
    ["@repeat"] = { fg = palette.pink },
    --["@label"] = { fg = colors.cyan },

    ["@keyword"] = { fg = palette.blue },
    ["@keyword.function"] = { fg = palette.blue },
    ["@keyword.return"] = { fg = palette.purple },
    ["@keyword.this"] = { fg = palette.blue },
    ["@keyword.export"] = { fg = palette.purple },
    ["@export"] = { fg = palette.purple },
    ["@keyword.coroutine"] = { fg = palette.purple },
    ["@keyword.operator"] = { fg = palette.purple },
    ["@keyword.conditional"] = { fg = palette.purple },
    ["@keyword.conditional.ternary"] = { fg = palette.fg },
    ["@keyword.import"] = { fg = palette.purple },
    ["@keyword.exception"] = { fg = palette.purple },
    ["@operator"] = { fg = palette.bright_white },
    ["@exception"] = { fg = palette.error_dark },
    ["@structure"] = { fg = palette.purple },
    ["@include"] = { fg = palette.purple },

    ["@variable"] = { fg = palette.blue_variable_name },
    ["@definition"] = { fg = palette.green },
    ["@variable.builtin"] = { fg = palette.blue_light },
    ["@constant"] = { fg = palette.blue_variable_name },
    ["@constant.builtin"] = { fg = palette.blue_medium },

    ["@text"] = { fg = palette.orange },
    ["@text.strong"] = { fg = palette.orange, bold = true }, -- bold
    ["@text.emphasis"] = { fg = palette.yellow, italic = true }, -- italic
    ["@text.underline"] = { fg = palette.orange },
    ["@text.title"] = { fg = palette.pink, bold = true }, -- title
    ["@text.literal"] = { fg = palette.yellow }, -- inline code
    ["@text.uri"] = { fg = palette.yellow, italic = true }, -- urls
    ["@text.reference"] = { fg = palette.orange, bold = true },

    ["@tag"] = { fg = palette.blue },
    ["@tag.attribute"] = { fg = palette.blue_light },
    ["@tag.delimiter"] = { fg = "#777777" },
    ["@tag.builtin.javascript"] = { fg = palette.blue },
    ["@tag.builtin.tsx"] = { fg = palette.blue },
    ["@tag.javascript"] = { fg = palette.blue_green },
    ["@tag.tsx"] = { fg = palette.blue_green },

    ["@type"] = { fg = palette.blue_green },
    ["@type.builtin"] = { fg = palette.blue_green, italic = true },
    ["@type.qualifier"] = { fg = palette.pink },

    -- Semantic
    ["@class"] = { fg = palette.blue_green },
    ["@struct"] = { fg = palette.blue },
    ["@enum"] = { fg = palette.blue },
    ["@enumMember"] = { fg = palette.purple },
    ["@event"] = { fg = palette.blue },
    ["@interface"] = { fg = palette.blue_light },
    ["@modifier"] = { fg = palette.blue },
    ["@regexp"] = { fg = palette.bright_red },
    ["@typeParameter"] = { fg = palette.blue_green },
    ["@decorator"] = { fg = palette.green },

    -- ["@comment.documentation"] = { fg = palette.comment },

    -- LSP Semantic tokens
    -- @see https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textDocument_semanticTokens

    ["@lsp.type.class"] = { fg = palette.blue_green },
    ["@lsp.type.decorator"] = { fg = palette.red },
    ["@lsp.type.enum"] = { fg = palette.red },
    ["@lsp.type.enumMember"] = { fg = palette.red },
    ["@lsp.type.function"] = { fg = palette.yellow },
    ["@lsp.type.interface"] = { fg = palette.blue_green },
    ["@lsp.type.macro"] = { fg = palette.orange },
    ["@lsp.type.method"] = { fg = palette.yellow },
    ["@lsp.type.namespace"] = { fg = palette.blue_green },
    ["@lsp.type.parameter"] = { fg = palette.blue_light },
    ["@lsp.type.property"] = { fg = palette.blue_light },
    ["@lsp.type.struct"] = { fg = palette.red },
    ["@lsp.type.type"] = { fg = palette.blue_green },
    ["@lsp.type.typeParameter"] = { fg = palette.number_green },
    ["@lsp.type.variable"] = {},

    ["@lsp.typemod.variable.unresolved"] = { fg = palette.error_dark },
    ["@lsp.typemod.variable.definition"] = { fg = palette.blue },

    ["@lsp.mod.deprecated"] = { strikethrough = true },
    ["@lsp.typemod.struct.builtin"] = { fg = palette.blue_green },
    ["@lsp.mod.builtin"] = { fg = palette.blue },

    -- scss
    ["@character.special.scss"] = { fg = palette.yellow_sunflower },

    -- HTML
    htmlArg = { fg = palette.green },
    htmlBold = { fg = palette.yellow, bold = true },
    htmlEndTag = { fg = palette.cyan },
    htmlH1 = { fg = palette.pink },
    htmlH2 = { fg = palette.pink },
    htmlH3 = { fg = palette.pink },
    htmlH4 = { fg = palette.pink },
    htmlH5 = { fg = palette.pink },
    htmlH6 = { fg = palette.pink },
    htmlItalic = { fg = palette.purple, italic = true },
    htmlLink = { fg = palette.purple, underline = true },
    htmlSpecialChar = { fg = palette.yellow },
    htmlSpecialTagName = { fg = palette.cyan },
    htmlTag = { fg = palette.cyan },
    htmlTagN = { fg = palette.cyan },
    htmlTagName = { fg = palette.cyan },
    htmlTitle = { fg = palette.white },

    -- Markdown
    markdownBlockquote = { fg = palette.yellow, italic = true },
    markdownBold = { fg = palette.orange, bold = true },
    markdownCode = { fg = palette.green },
    markdownCodeBlock = { fg = palette.orange },
    markdownCodeDelimiter = { fg = palette.red },
    markdownH1 = { fg = palette.pink, bold = true },
    markdownH2 = { fg = palette.pink, bold = true },
    markdownH3 = { fg = palette.pink, bold = true },
    markdownH4 = { fg = palette.pink, bold = true },
    markdownH5 = { fg = palette.pink, bold = true },
    markdownH6 = { fg = palette.pink, bold = true },
    markdownHeadingDelimiter = { fg = palette.red },
    markdownHeadingRule = { fg = palette.fade },
    markdownId = { fg = palette.purple },
    markdownIdDeclaration = { fg = palette.cyan },
    markdownIdDelimiter = { fg = palette.purple },
    markdownItalic = { fg = palette.yellow, italic = true },
    markdownLinkDelimiter = { fg = palette.purple },
    markdownLinkText = { fg = palette.pink },
    markdownListMarker = { fg = palette.cyan },
    markdownOrderedListMarker = { fg = palette.red },
    markdownRule = { fg = palette.fade },

    --  Diff
    diffAdded = { fg = palette.green },
    diffRemoved = { fg = palette.red },
    diffFileId = { fg = palette.yellow, bold = true, reverse = true },
    diffFile = { fg = palette.nontext },
    diffNewFile = { fg = palette.green },
    diffOldFile = { fg = palette.red },

    debugPc = { bg = palette.cyan },
    debugBreakpoint = { fg = palette.red, reverse = true },

    -- Git Signs
    GitSignsAdd = { fg = palette.bright_green },
    GitSignsChange = { fg = palette.cyan },
    GitSignsDelete = { fg = palette.bright_red },
    GitSignsAddLn = { fg = palette.black, bg = palette.bright_green },
    GitSignsChangeLn = { fg = palette.black, bg = palette.cyan },
    GitSignsDeleteLn = { fg = palette.black, bg = palette.bright_red },
    GitSignsCurrentLineBlame = { fg = palette.white },

    -- Telescope
    TelescopePromptBorder = { fg = palette.fade },
    TelescopeResultsBorder = { fg = palette.fade },
    TelescopePreviewBorder = { fg = palette.fade },
    TelescopeSelection = { fg = palette.bright_white, bg = palette.visual_bg },
    TelescopeMultiSelection = { fg = palette.green, bg = palette.visual_bg },
    TelescopeNormal = { fg = palette.white, bg = palette.bg },
    TelescopeMatching = { fg = palette.green },
    TelescopePromptPrefix = { fg = palette.bright_magenta },

    -- Fzf-lua
    FzfLuaBorder = { fg = palette.fade },
    FzfLuaTitle = { fg = palette.white },
    FzfLuaCursor = { fg = palette.white },
    FzfLuaCursorLine = { bg = palette.visual_bg },
    FzfLuaCursorLineNumber = { fg = palette.fade },
    FzfLuaSearch = { bg = palette.green },

    -- Oil
    OilHidden = { fg = palette.nontext },
    OilFile = { fg = palette.fg },
    OilFileHidden = { fg = palette.nontext },
    OilDir = { fg = palette.fg },
    OilDirHidden = { fg = palette.nontext },
    OilDirIcon = { fg = palette.yellow_orange },

    -- NeoTree
    NeoTreeNormal = { fg = palette.fg, bg = palette.menu },
    NeoTreeNormalNC = { fg = palette.fg, bg = palette.menu },
    NeoTreeDirectoryName = { fg = palette.fg },
    NeoTreeDirectoryIcon = { fg = palette.yellow_orange },
    NeoTreeGitUnstaged = { fg = palette.bright_magenta },
    NeoTreeGitModified = { fg = palette.yellow_sunflower },
    NeoTreeGitUntracked = { fg = palette.bright_green },
    NeoTreeIndentMarker = { fg = palette.fade },
    NeoTreeDotfile = { fg = palette.text_ignored },
    NeoTreeCursorLine = { bg = palette.visual_bg },

    -- NeoTreeBufferNumber       The buffer number shown in the buffers source.
    -- NeoTreeCursorLine         |hl-CursorLine| override in Neo-tree window.
    -- NeoTreeDimText            Greyed out text used in various places.
    -- NeoTreeDirectoryIcon      Directory icon.
    -- NeoTreeDirectoryName      Directory name.
    -- NeoTreeDotfile            Used for icons and names when dotfiles are filtered.
    -- NeoTreeFileIcon           File icon, when not overridden by devicons.
    -- NeoTreeFileName           File name, when not overwritten by another status.
    -- NeoTreeFileNameOpened     File name when the file is open. Not used yet.
    -- NeoTreeFilterTerm         The filter term, as displayed in the root node.
    -- NeoTreeFloatBorder        The border for pop-up windows.
    -- NeoTreeFloatTitle         Used for the title text of pop-ups when the border-style
    --                           is set to another style than "NC". This is derived
    --                           from NeoTreeFloatBorder.
    -- NeoTreeTitleBar           Used for the title bar of pop-ups, when the border-style
    --                           is set to "NC". This is derived from NeoTreeFloatBorder.
    -- NeoTreeGitAdded           File name when the git status is added.
    -- NeoTreeGitConflict        File name when the git status is conflict.
    -- NeoTreeGitDeleted         File name when the git status is deleted.
    -- NeoTreeGitIgnored         File name when the git status is ignored.
    -- NeoTreeGitModified        File name when the git status is modified.
    -- NeoTreeGitUnstaged        Used for git unstaged symbol.
    -- NeoTreeGitUntracked       File name when the git status is untracked.
    -- NeoTreeGitStaged          Used for git staged symbol.
    -- NeoTreeHiddenByName       Used for icons and names when `hide_by_name` is used.
    -- NeoTreeIndentMarker       The style of indentation markers (guides). By default,
    --                           the "Normal" highlight is used.
    -- NeoTreeExpander           Used for collapsed/expanded icons.
    -- NeoTreeNormal             |hl-Normal| override in Neo-tree window.
    -- NeoTreeNormalNC           |hl-NormalNC| override in Neo-tree window.
    -- NeoTreeSignColumn         |hl-SignColumn| override in Neo-tree window.
    -- NeoTreeStatusLine         |hl-StatusLine| override in Neo-tree window.
    -- NeoTreeStatusLineNC       |hl-StatusLineNC| override in Neo-tree window.
    -- NeoTreeVertSplit          |hl-VertSplit| override in Neo-tree window.
    -- NeoTreeWinSeparator       |hl-WinSeparator| override in Neo-tree window.
    -- NeoTreeEndOfBuffer        |hl-EndOfBuffer| override in Neo-tree window.
    -- NeoTreeRootName           The name of the root node.
    -- NeoTreeSymbolicLinkTarget Symbolic link target.
    -- NeoTreeTitleBar           Used for the title bar of pop-ups, when the border-style
    --                           is set to "NC". This is derived from NeoTreeFloatBorder.
    -- NeoTreeWindowsHidden      Used for icons and names that are hidden on Windows.

    -- Noice
    NoiceMini = { bg = palette.bg },
    NoiceVirtualText = { fg = palette.bright_magenta }, -- Search result and such

    -- Noice lsp
    NoiceLspProgressTitle = { fg = palette.white },
    NoiceLspProgressSpinner = { fg = palette.bright_magenta },
    NoiceLspProgressDone = { fg = palette.bright_green },
    NoiceLspProgressClient = { fg = palette.bright_magenta },
    NoiceLspProgressBar = { bg = palette.nontext },
    NoiceFormatProgressTodo = { bg = palette.bright_magenta },
    NoiceFormatProgressDone = { bg = palette.bright_green },

    -- Noice Cmd line
    NoiceCmdlineIcon = { fg = palette.bright_magenta },
    -- These map to cmdlineIcon
    -- NoiceCmdlineIconCalculator = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconCmdline = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconFilter = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconHelp = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconIncRename = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconInput = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlineIconLua = { fg = palette.white, bg = palette.bg },
    NoiceCmdlineIconSearch = { fg = palette.bright_magenta },
    NoiceCmdlinePopup = { fg = palette.fg, bg = nil },
    NoiceCmdlinePopupBorder = { fg = palette.fade, bg = nil },
    -- These map to cmdlinePopupBorder, I don't want differing colors for now
    -- NoiceCmdlinePopupBorderCalculator = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderCmdline = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderFilter = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderHelp = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderIncRename = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderInput = { fg = palette.white, bg = palette.bg },
    -- NoiceCmdlinePopupBorderLua = { fg = palette.white, bg = palette.bg },
    NoiceCmdlinePopupBorderSearch = { fg = palette.fade },
    NoiceCmdlinePopupTitle = { fg = palette.bright_magenta, bg = nil },
    NoiceCmdlinePrompt = { fg = palette.white, bg = palette.bg },

    -- LSP
    DiagnosticError = { fg = palette.red },
    DiagnosticWarn = { fg = palette.yellow },
    DiagnosticInfo = { fg = palette.cyan },
    DiagnosticHint = { fg = palette.number_green },
    DiagnosticUnderlineError = { undercurl = true, sp = palette.red },
    DiagnosticUnderlineWarn = { undercurl = true, sp = palette.yellow },
    DiagnosticUnderlineInfo = { undercurl = true, sp = palette.cyan },
    DiagnosticUnderlineHint = { undercurl = true, sp = palette.number_green },
    DiagnosticSignError = { fg = palette.red },
    DiagnosticSignWarn = { fg = palette.yellow },
    DiagnosticSignInfo = { fg = palette.cyan },
    DiagnosticSignHint = { fg = palette.number_green },
    DiagnosticFloatingError = { fg = palette.red },
    DiagnosticFloatingWarn = { fg = palette.yellow },
    DiagnosticFloatingInfo = { fg = palette.cyan },
    DiagnosticFloatingHint = { fg = palette.number_green },
    DiagnosticVirtualTextError = { fg = palette.red },
    DiagnosticVirtualTextWarn = { fg = palette.yellow },
    DiagnosticVirtualTextInfo = { fg = palette.cyan },
    DiagnosticVirtualTextHint = { fg = palette.number_green },

    LspDiagnosticsDefaultError = { fg = palette.red },
    LspDiagnosticsDefaultWarning = { fg = palette.yellow },
    LspDiagnosticsDefaultInformation = { fg = palette.cyan },
    LspDiagnosticsDefaultHint = { fg = palette.number_green },
    LspDiagnosticsUnderlineError = { fg = palette.red, undercurl = true },
    LspDiagnosticsUnderlineWarning = { fg = palette.yellow, undercurl = true },
    LspDiagnosticsUnderlineInformation = { fg = palette.cyan, undercurl = true },
    LspDiagnosticsUnderlineHint = { fg = palette.number_green, undercurl = true },
    LspReferenceText = { fg = palette.orange },
    LspReferenceRead = { fg = palette.orange },
    LspReferenceWrite = { fg = palette.orange },
    LspCodeLens = { fg = palette.cyan },

    -- LSP Saga
    -- see https://github.com/nvimdev/lspsaga.nvim/blob/main/lua/lspsaga/highlight.lua
    SagaTitle = { link = "Title" },
    SagaBorder = { fg = palette.border },
    SagaNormal = { link = "NormalFloat" },
    SagaToggle = { link = "Comment" },
    SagaBeacon = { bg = "#c43963" },
    SagaVirtLine = { fg = palette.border },
    SagaSpinnerTitle = { link = "Statement" },
    SagaSpinner = { link = "Statement" },
    SagaText = { link = "Comment" },
    SagaSelect = { link = "String" },
    SagaSearch = { link = "Search" },
    SagaFinderFname = { link = "Function" },
    SagaDetail = { link = "Comment" },
    SagaInCurrent = { link = "KeyWord" },
    SagaCount = { bg = "gray", fg = "white", bold = true },
    SagaSep = { link = "Comment" },

    ActionFix = { link = "Keyword" },
    ActionPreviewNormal = { link = "SagaNormal" },
    ActionPreviewBorder = { link = "SagaBorder" },
    ActionPreviewTitle = { link = "Title" },
    CodeActionText = { fg = palette.fg },
    CodeActionNumber = { fg = palette.white },

    DiagnosticBorder = { fg = palette.border },
    DiagnosticShowBorder = { fg = palette.border },

    -- Highlight current word
    -- Tried to emmulate vscodde but its unclear
    IlluminatedWordText = { bg = palette.fade },
    IlluminatedWordRead = { bg = palette.cursor_word_yellow },
    IlluminatedWordWrite = { bg = palette.cursor_word_blue },

    -- -- Cmp
    -- -- NOTE: Pmenu controls background
    -- -- NOTE: CmpGhostText is a custom hlgroup
    CmpGhostText = { fg = palette.white },
    -- Text
    CmpItemAbbr = { fg = palette.fg },
    -- Source
    CmpItemKind = { fg = palette.white },
    -- REVIEW: Not sure where "match" are used
    CmpItemAbbrMatch = { fg = "#569CD6" },
    CmpItemAbbrMatchFuzzy = { fg = palette.bright_green },
    CmpItemAbbrDeprecated = { strikethrough = true, fg = palette.error_dark },
    CmpItemKindMethod = { link = "@method" },
    CmpItemKindText = { link = "@text" },
    CmpItemKindFunction = { link = "@function" },
    CmpItemKindConstructor = { link = "@type" },
    CmpItemKindVariable = { link = "@variable" },
    CmpItemKindClass = { link = "@type" },
    CmpItemKindInterface = { link = "@type" },
    CmpItemKindModule = { link = "@namespace" },
    CmpItemKindProperty = { link = "@property" },
    CmpItemKindOperator = { link = "@operator" },
    CmpItemKindReference = { link = "@parameter.reference" },
    CmpItemKindUnit = { link = "@field" },
    CmpItemKindValue = { link = "@field" },
    CmpItemKindField = { link = "@field" },
    CmpItemKindEnum = { link = "@field" },
    CmpItemKindKeyword = { link = "@keyword" },
    CmpItemKindSnippet = { link = "@text" },
    CmpItemKindColor = { link = "DevIconCss" },
    CmpItemKindFile = { link = "NeoTreeDirectoryName" },
    CmpItemKindFolder = { link = "NeoTreeDirectoryIcon" },
    CmpItemKindEvent = { link = "@constant" },
    CmpItemKindEnumMember = { link = "@field" },
    CmpItemKindConstant = { link = "@constant" },
    CmpItemKindStruct = { link = "@structure" },
    CmpItemKindTypeParameter = { link = "@parameter" },

    -- Treesitter rainbow delimiter colors
    RainbowDelimiterYellow = { fg = palette.yellow_sunflower },
    RainbowDelimiterViolet = { fg = palette.pink },
    RainbowDelimiterBlue = { fg = palette.blue },
    -- For intentation lines
    RainbowDelimiterYellowMuted = { fg = "#e3cf8b" },
    RainbowDelimiterVioletMuted = { fg = "#b74b89" },
    RainbowDelimiterBlueMuted = { fg = "#4a7396" },

    -- Nvim-Scrollbar
    ScrollbarHandle = { fg = nil, bg = palette.border },
    ScrollbarCursorHandle = { fg = palette.white, bg = palette.white },
    -- ScrollbarCursor
    -- ScrollbarSearchHandle
    -- ScrollbarSearch
    -- ScrollbarErrorHandle
    -- ScrollbarError
    -- ScrollbarWarnHandle
    -- ScrollbarWarn
    -- ScrollbarInfoHandle
    -- ScrollbarInfo
    -- ScrollbarHintHandle
    -- ScrollbarHint
    -- ScrollbarMiscHandle
    -- ScrollbarMisc
    -- ScrollbarGitAdd
    -- ScrollbarGitAddHandle
    -- ScrollbarGitChange
    -- ScrollbarGitChangeHandle
    -- ScrollbarGitDelete
    -- ScrollbarGitDeleteHandle

    -- Yanky
    YankyPut = { bg = "#8ee592", fg = "#333333" },
    YankyYanked = { bg = "#8ee592", fg = "#333333" },

    -- Neotest
    NeotestAdapterName = { fg = palette.bright_blue },
    NeotestBorder = { fg = palette.border },
    NeotestDir = { fg = palette.yellow },
    NeotestExpandMarker = { fg = palette.white },
    NeotestFailed = { fg = palette.bright_red },
    NeotestFile = { fg = palette.blue_green },
    NeotestFocused = { bg = palette.visual_bg },
    NeotestIndent = { fg = palette.fade },
    NeotestMarked = { fg = palette.yellow_sunflower },
    NeotestNamespace = { fg = palette.white },
    NeotestPassed = { fg = palette.green },
    NeotestRunning = { fg = palette.number_green },
    NeotestWinSelect = { fg = palette.pink },
    NeotestSkipped = { fg = palette.nontext },
    NeotestTarget = { fg = palette.orange },
    NeotestTest = { fg = palette.fg },
    NeotestUnknown = { fg = palette.text_ignored },
    NeotestWatching = { fg = palette.purple },

    -- WhichKey
    WhichKey = { fg = palette.fg },
    WhichKeyGroup = { fg = palette.pink },
    WhichKeySeparator = { fg = palette.fade }, -- DiffAdd the separator between the key and its label
    WhichKeyDesc = { fg = palette.white }, -- Identifier the label of the key
    -- WhichKeyFloat = {}, -- NormalFloat Normal in the popup window
    -- WhichKeyBorder = {}, -- FloatBorder Normal in the popup window
    WhichKeyValue = { fg = palette.blue_green },

    -- Treesitter context
    TreesitterContext = { bg = nil },
    TreesitterContextLineNumber = { fg = palette.fade },
    TreesitterContextSeparator = { fg = palette.white },
    TreesitterContextBottom = require("neovide").ctx_is_neovide() and { underline = true, sp = palette.white } or {},
    TreesitterContextLineNumberBottom = require("neovide").ctx_is_neovide()
        and { underline = true, sp = palette.white }
      or {},

    -- Visual multi
    VMMono = { bg = palette.visual_bg },
    VMExtend = { bg = palette.visual_bg },
    VMCursor = { bg = palette.pink },
    VMInsert = { bg = palette.visual_bg },

    -- Glance

    -- GlancePreviewNormal
    GlancePreviewMatch = { bg = palette.yellow_orange, fg = palette.fade },
    GlancePreviewCursorLine = { bg = palette.cursor_word_yellow },
    -- GlancePreviewSignColumn
    GlancePreviewEndOfBuffer = { fg = palette.bg },
    -- GlancePreviewLineNr
    -- GlancePreviewBorderBottom
    GlanceWinBarTitle = { bg = palette.menu, fg = palette.white },
    GlanceWinBarFilename = { fg = palette.blue_green },
    GlanceWinBarFilepath = { fg = palette.fade },
    GlanceListNormal = { bg = palette.bg, fg = palette.white },
    GlanceListFilename = { fg = palette.blue_green },
    GlanceListFilepath = { fg = palette.fade },
    GlanceListCount = { fg = palette.number_green },
    GlanceListMatch = { bg = palette.yellow_orange, fg = palette.fade },
    GlanceListCursorLine = { bg = palette.visual_bg, fg = palette.fg },
    -- GlanceListEndOfBuffer
    -- GlanceListBorderBottom
    -- GlanceFoldIcon
    -- GlanceIndent
    -- GlanceBorderTop

    -- Render-markdown.nvim
    RenderMarkdownH1Bg = { bg = "#666666" },
    RenderMarkdownH2Bg = { bg = "#555555" },
    RenderMarkdownH3Bg = { bg = "#444444" },
    RenderMarkdownH4Bg = { bg = "#333333" },
    RenderMarkdownH5Bg = { bg = "#222222" },
    RenderMarkdownH6Bg = { bg = "#111111" },
  }
end

return M
