return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
    config = function()
      require('config.plugins.mason-lspconfig')
    end,
  },
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    dependencies = {
      { 'Bilal2453/luvit-meta', lazy = true },
    },
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },
  {
    'glepnir/lspsaga.nvim',
    event = 'LspAttach',
    config = function()
      require('config.plugins.lspsaga')
    end,
  },
}
