vim.g.syntax_on = true

-- Sync clipboard between OS and Neovim.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'
-- vim.cmd('colorscheme gruvbox')
vim.cmd('colorscheme onedark')

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'

vim.opt.termguicolors = true
vim.o.guifont = "JetBrainsMono Nerd Font:h16" -- text below applies for VimScript
vim.o.mouse = 'a'
vim.wo.number = true
vim.wo.signcolumn = 'yes'

vim.opt.title = true
vim.opt.hlsearch = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true -- tabs are spaces
vim.opt.wrap = false     -- No Wrap lines
vim.o.undofile = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect,noinsert'

vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }

vim.opt.rtp:append('/opt/homebrew/opt/fzf')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- set highlight for selection
-- green
-- vim.cmd[[highlight Visual gui=bold guibg=#0E191F guifg=#60B950]]
-- orange
vim.cmd [[highlight Visual gui=bold guibg=#3E4452 guifg=#FFAB00]]

-- config for fzf-project
vim.g['fzfSwitchProjectWorkspaces'] = {
  '/Users/shaun.wen/workspace/projects/scalapay-repos',
  '/Users/shaun.wen/repo/learning/rust'
}
vim.g['fzfSwitchProjectProjects'] = {
  '/Users/shaun.wen/.config/nvim',
  '/Users/shaun.wen/Documents/myNotes'
}
vim.g['fzfSwitchProjectAlwaysChooseFile'] = 0
vim.g['fzfSwitchProjectCloseOpenedBuffers'] = 1

-- disable some functionalities if neovim freezes when opening big files
local aug = vim.api.nvim_create_augroup("buf_large", { clear = true })
vim.api.nvim_create_autocmd({ "BufReadPre" }, {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))
    if ok and stats and (stats.size > 100000) then
      vim.b.large_buf = true
      -- vim.cmd("syntax off") I don't yet need to turn the syntax off
      vim.opt_local.spell = false
      vim.cmd("IndentBlanklineDisable") -- disable indent-blankline.nvim
      vim.opt_local.foldmethod = "manual"
    else
      vim.b.large_buf = false
    end
  end,
  group = aug,
  pattern = "*",
})
