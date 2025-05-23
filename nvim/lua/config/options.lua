-- config/options.lua
local opt = vim.opt

opt.autoindent = true
opt.cursorline = true
opt.clipboard = 'unnamedplus'
opt.colorcolumn = '120'
opt.compatible = false
opt.expandtab = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.smartindent = true
opt.showmatch = true
opt.softtabstop = 2
opt.scrolloff = 5
opt.shiftwidth = 2
opt.tabstop = 2
opt.termguicolors = true
opt.wildmode = { 'longest', 'list' }

vim.cmd [[highlight LineNr guifg=#C8C8C8]]
vim.api.nvim_set_hl(0, "SpecialKey", { fg = "#FFD700" })

-- Set highlight untuk nvim-cmp popup menu
vim.api.nvim_set_hl(0, 'CmpItemAbbr', { fg = '#ffffff', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpItemAbbrMatch', { fg = '#ff9d00', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpItemKind', { fg = '#b5cea8', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpItemMenu', { fg = '#a9b7c6', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpDocBorder', { fg = '#3e3e3e', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpDoc', { fg = '#dcdcdc', bg = '#1e1e1e' })
vim.api.nvim_set_hl(0, 'CmpItemSel', { fg = '#ffffff', bg = '#007acc' })

-- opt.spell = true
-- opt.swapfile = false
-- opt.backupdir = vim.fn.expand('~/.cache/vim')
