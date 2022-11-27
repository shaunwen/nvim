vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.o.background = 'dark'
vim.wo.number = true
vim.opt.signcolumn = 'yes'

vim.opt.title = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.hlsearch = false
vim.opt.backup = false
vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.expandtab = true
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false -- No Wrap lines

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }

vim.g.mapleader = " "

-- Plugin: easymotion
-- Turn on case-insensitive feature
vim.g.EasyMotion_smartcase = 1
-- Smartsign (type `3` and match `3`&`#`)
vim.g.EasyMotion_use_smartsign_us = 1
vim.g.multi_cursor_select_all_word_key = '<S-C-a>'
vim.g.multi_cursor_select_all_key      = 'g<S-C-a>'
