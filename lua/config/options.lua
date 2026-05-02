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

-- Treesitter folding — set early so folds stay open when treesitter loads later
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldtext = 'v:lua.custom_foldtext()'
vim.opt.fillchars:append({ fold = ' ' })
vim.opt.foldlevelstart = 99
vim.opt.foldlevel = 99

function _G.custom_foldtext()
  local raw_line = vim.fn.getline(vim.v.foldstart)
  local heading_prefix = raw_line:match('^%s*#+%s*') or ''
  local line = raw_line:gsub('^%s*#+%s*', '')
  local folded_lines = vim.v.foldend - vim.v.foldstart
  local suffix = folded_lines == 1 and 'line' or 'lines'

  return ('%s%s [%d %s]'):format((' '):rep(#heading_prefix), line, folded_lines, suffix)
end

vim.opt.path:append({ '**' })
vim.opt.wildignore:append({ '*/node_modules/*' })

vim.filetype.add({
  filename = {
    ['go.work'] = 'gowork',
  },
  extension = {
    gotmpl = 'gotmpl',
  },
})
