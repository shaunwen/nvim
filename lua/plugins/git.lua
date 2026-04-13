return {
  { 'tpope/vim-fugitive', lazy = false },
  {
    'tommcdo/vim-fubitive',
    lazy = false,
    init = function()
      vim.g.fugitive_bitbucket_domains = { 'https://bitbucket.org' }
    end,
  },
  { 'tpope/vim-rhubarb', lazy = false },
  {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFileHistory',
    },
    keys = {
      { '<Leader>gD', '<cmd>DiffviewOpen<CR>', desc = 'Open Diffview' },
      { '<Leader>gC', '<cmd>DiffviewClose<CR>', desc = 'Close Diffview' },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('config.plugins.gitsigns')
    end,
  },
}
