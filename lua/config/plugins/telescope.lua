-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')
pcall(require('telescope').load_extension, 'harpoon')

-- fix folding https://github.com/nvim-telescope/telescope.nvim/issues/699#issuecomment-1364538472
vim.api.nvim_create_autocmd({ 'BufEnter' }, {
  pattern = { '*' },
  command = 'normal zx',
})
