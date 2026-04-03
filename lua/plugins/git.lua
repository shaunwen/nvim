return {
  { 'tpope/vim-fugitive', lazy = false },
  {
    'tommcdo/vim-fubitive',
    lazy = false,
    init = function()
      vim.g.fubitive_domain_pattern = 'code\\.example\\.com'
      vim.g.fubitive_domain_context_path = 'bitbucket'
    end,
  },
  { 'tpope/vim-rhubarb', lazy = false },
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('config.plugins.gitsigns')
    end,
  },
}
