-- Kanagawa Mint-Csupo — Neovim colorscheme (spec v1.3.0)
-- Dark Lunch Studios · CC BY-SA 4.0 · palette derived from kanagawa.nvim (MIT)
-- Install: drop in ~/.config/nvim/colors/ then :colorscheme kanagawa-mint-csupo

vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then vim.cmd('syntax reset') end
vim.o.termguicolors = true
vim.g.colors_name = 'kanagawa-mint-csupo'

local p = {
  bg      = '#1f1f28', chrome  = '#181820', panel  = '#1a1a22', ink    = '#16161d',
  border  = '#2a2a37', hover   = '#223249', sel    = '#2d4f67',
  fg      = '#c8c093', bright  = '#dcd7ba', muted  = '#727169', ghost  = '#54546d',
  mint    = '#54e3b2', keyword = '#b06ecf', type   = '#7e9cd8', var    = '#e6c384',
  const   = '#ff9e3b', str     = '#98bb6c', num    = '#e46876', patina = '#7aa89f',
  sky     = '#7fb4ca', red     = '#c34043', gold   = '#c0a36e', violet = '#957fb8',
}

local hl = function(group, opts) vim.api.nvim_set_hl(0, group, opts) end

-- UI
hl('Normal',        { fg = p.fg, bg = p.bg })
hl('NormalFloat',   { fg = p.fg, bg = p.panel })
hl('FloatBorder',   { fg = p.border, bg = p.panel })
hl('ColorColumn',   { bg = p.panel })
hl('Cursor',        { fg = p.ink, bg = p.mint })
hl('CursorLine',    { bg = p.hover })
hl('CursorLineNr',  { fg = p.mint, bold = true })
hl('LineNr',        { fg = p.muted })
hl('SignColumn',    { bg = p.bg })
hl('VertSplit',     { fg = p.border })
hl('WinSeparator',  { fg = p.border })
hl('StatusLine',    { fg = p.fg, bg = p.chrome })
hl('StatusLineNC',  { fg = p.muted, bg = p.chrome })
hl('TabLine',       { fg = p.muted, bg = p.panel })
hl('TabLineFill',   { bg = p.chrome })
hl('TabLineSel',    { fg = p.fg, bg = p.bg, sp = p.mint, underline = true })
hl('Pmenu',         { fg = p.fg, bg = p.panel })
hl('PmenuSel',      { fg = p.bright, bg = p.sel })
hl('PmenuSbar',     { bg = p.panel })
hl('PmenuThumb',    { bg = p.ghost })
hl('Visual',        { bg = p.sel })
hl('Search',        { fg = p.ink, bg = p.mint })
hl('IncSearch',     { fg = p.ink, bg = p.const })
hl('CurSearch',     { fg = p.ink, bg = p.const })
hl('MatchParen',    { fg = p.mint, bold = true, underline = true })
hl('Folded',        { fg = p.muted, bg = p.panel })
hl('NonText',       { fg = p.ghost })
hl('Whitespace',    { fg = p.ghost })
hl('SpecialKey',    { fg = p.ghost })
hl('Directory',     { fg = p.type })
hl('Title',         { fg = p.num, bold = true })
hl('ErrorMsg',      { fg = p.num })
hl('WarningMsg',    { fg = p.var })
hl('MoreMsg',       { fg = p.mint })
hl('Question',      { fg = p.mint })
hl('WildMenu',      { fg = p.bright, bg = p.sel })

-- Syntax (spec section 3)
hl('Comment',       { fg = p.muted, italic = true })
hl('Constant',      { fg = p.const })
hl('String',        { fg = p.str })
hl('Character',     { fg = p.str })
hl('Number',        { fg = p.num })
hl('Float',         { fg = p.num })
hl('Boolean',       { fg = p.const })
hl('Identifier',    { fg = p.var })
hl('Function',      { fg = p.mint })
hl('Statement',     { fg = p.keyword })
hl('Keyword',       { fg = p.keyword })
hl('Conditional',   { fg = p.keyword })
hl('Repeat',        { fg = p.keyword })
hl('Label',         { fg = p.keyword })
hl('Operator',      { fg = p.fg })
hl('Exception',     { fg = p.keyword })
hl('PreProc',       { fg = p.keyword })
hl('Type',          { fg = p.type })
hl('StorageClass',  { fg = p.keyword })
hl('Structure',     { fg = p.type })
hl('Typedef',       { fg = p.type })
hl('Special',       { fg = p.const })
hl('SpecialChar',   { fg = p.const })
hl('Tag',           { fg = p.keyword })
hl('Delimiter',     { fg = p.fg })
hl('Underlined',    { fg = p.sky, underline = true })
hl('Error',         { fg = p.num })
hl('Todo',          { fg = p.ink, bg = p.mint, bold = true })

-- Treesitter
hl('@variable',            { fg = p.var })
hl('@variable.parameter',  { fg = p.var, italic = true })
hl('@variable.member',     { fg = p.var })
hl('@property',            { fg = p.const })
hl('@constant',            { fg = p.const })
hl('@function',            { fg = p.mint })
hl('@function.method',     { fg = p.mint })
hl('@constructor',         { fg = p.mint })
hl('@keyword',             { fg = p.keyword })
hl('@type',                { fg = p.type })
hl('@module',              { fg = p.sky })
hl('@string',              { fg = p.str })
hl('@string.regexp',       { fg = p.num })
hl('@string.escape',       { fg = p.const })
hl('@number',              { fg = p.num })
hl('@comment',             { fg = p.muted, italic = true })
hl('@punctuation',         { fg = p.fg })
hl('@operator',            { fg = p.fg })
hl('@tag',                 { fg = p.keyword })
hl('@tag.attribute',       { fg = p.var })
hl('@markup.heading',      { fg = p.num, bold = true })
hl('@markup.strong',       { fg = p.const, bold = true })
hl('@markup.italic',       { fg = p.mint, italic = true })
hl('@markup.link',         { fg = p.sky })
hl('@markup.raw',          { fg = p.str })

-- Diagnostics
hl('DiagnosticError', { fg = p.num })
hl('DiagnosticWarn',  { fg = p.var })
hl('DiagnosticInfo',  { fg = p.type })
hl('DiagnosticHint',  { fg = p.muted })
hl('DiagnosticUnderlineError', { sp = p.num, undercurl = true })
hl('DiagnosticUnderlineWarn',  { sp = p.var, undercurl = true })

-- Diff / git
hl('DiffAdd',     { bg = '#243020' })
hl('DiffChange',  { bg = '#3a2e1a' })
hl('DiffDelete',  { fg = p.red, bg = '#401515' })
hl('DiffText',    { bg = p.sel })
hl('Added',       { fg = '#76946a' })
hl('Changed',     { fg = p.gold })
hl('Removed',     { fg = p.red })
hl('GitSignsAdd',    { fg = '#76946a' })
hl('GitSignsChange', { fg = p.gold })
hl('GitSignsDelete', { fg = p.red })

-- Terminal palette (spec section 4)
vim.g.terminal_color_0  = '#16161d'; vim.g.terminal_color_8  = '#54546d'
vim.g.terminal_color_1  = '#c34043'; vim.g.terminal_color_9  = '#e46876'
vim.g.terminal_color_2  = '#76946a'; vim.g.terminal_color_10 = '#98bb6c'
vim.g.terminal_color_3  = '#c0a36e'; vim.g.terminal_color_11 = '#e6c384'
vim.g.terminal_color_4  = '#7e9cd8'; vim.g.terminal_color_12 = '#7fb4ca'
vim.g.terminal_color_5  = '#957fb8'; vim.g.terminal_color_13 = '#938aa9'
vim.g.terminal_color_6  = '#54e3b2'; vim.g.terminal_color_14 = '#7aa89f'
vim.g.terminal_color_7  = '#dcd7ba'; vim.g.terminal_color_15 = '#ffffff'
