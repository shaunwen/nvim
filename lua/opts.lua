vim.cmd("autocmd!")

vim.g.mapleader = " "
vim.g.syntax_on = true
vim.opt.clipboard:append { "unnamedplus" }
vim.cmd('colorscheme gruvbox')

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.termguicolors = true
vim.o.guifont = "JetBrainsMono Nerd Font:h16" -- text below applies for VimScript
vim.wo.number = true
vim.opt.signcolumn = 'yes'

vim.opt.title = true
vim.opt.smartindent = true
vim.opt.hlsearch = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true -- tabs are spaces
vim.opt.wrap = false -- No Wrap lines

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }

vim.opt.rtp:append('/opt/homebrew/opt/fzf')

-- config for fzf-project
vim.g['fzfSwitchProjectWorkspaces'] = {
  '/Users/shaun.wen/workspace/projects/scalapay-repos',
  '/Users/shaun.wen/workspace/projects/magic-repos',
  '/Users/shaun.wen/repo/learning/rust'
}
vim.g['fzfSwitchProjectProjects'] = {
  '/Users/shaun.wen/.config/nvim',
  '/Users/shaun.wen/repo/learning/rust/swc'
}
vim.g['fzfSwitchProjectAlwaysChooseFile'] = 0
vim.g['fzfSwitchProjectCloseOpenedBuffers'] = 1
