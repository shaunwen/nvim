vim.api.nvim_set_hl(0, 'LspMark', { link = 'DiagnosticWarn' })
vim.api.nvim_set_hl(0, 'LspMarkComment', { link = 'Comment' })

require('lspmark').setup()

local bookmarks = require('lspmark.bookmarks')

bookmarks.load_bookmarks()

vim.api.nvim_create_autocmd('DirChanged', {
  group = vim.api.nvim_create_augroup('LspmarkBookmarks', { clear = true }),
  callback = function()
    bookmarks.load_bookmarks()
  end,
})
