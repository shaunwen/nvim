vim.g.syntax_on = true

-- Sync clipboard between OS and Neovim.
vim.o.clipboard = 'unnamedplus'

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'

vim.opt.termguicolors = true
vim.o.guifont = 'JetBrainsMono Nerd Font:h16'
vim.o.mouse = 'a'
vim.o.number = true
vim.wo.signcolumn = 'yes'

vim.opt.title = true
vim.opt.hlsearch = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.o.undofile = true

vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.o.completeopt = 'menuone,noselect,noinsert'

vim.opt.path:append({ '**' })
vim.opt.wildignore:append({ '*/node_modules/*' })
