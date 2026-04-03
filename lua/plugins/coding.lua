return {
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('config.plugins.autopairs')
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    config = function()
      require('config.plugins.ts-autotag')
    end,
  },
  {
    'numToStr/Comment.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.plugins.comment')
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    config = function()
      require('config.plugins.nvim-treesitter')
    end,
  },
  {
    'ThePrimeagen/refactoring.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>re',
        function()
          return require('refactoring').refactor('Extract Function')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Extract function',
      },
      {
        '<leader>rf',
        function()
          return require('refactoring').refactor('Extract Function To File')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Extract function to file',
      },
      {
        '<leader>rv',
        function()
          return require('refactoring').refactor('Extract Variable')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Extract variable',
      },
      {
        '<leader>rI',
        function()
          return require('refactoring').refactor('Inline Function')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Inline function',
      },
      {
        '<leader>ri',
        function()
          return require('refactoring').refactor('Inline Variable')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Inline variable',
      },
      {
        '<leader>rbb',
        function()
          return require('refactoring').refactor('Extract Block')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Extract block',
      },
      {
        '<leader>rbf',
        function()
          return require('refactoring').refactor('Extract Block To File')
        end,
        expr = true,
        mode = { 'n', 'x' },
        desc = 'Extract block to file',
      },
      {
        '<Leader>rp',
        ":lua require('refactoring').debug.printf({ below = true })<CR>",
        mode = { 'n', 'x' },
        desc = 'Debug printf',
      },
      {
        '<Leader>rc',
        ":lua require('refactoring').debug.cleanup({})<CR>",
        mode = 'n',
        desc = 'Debug cleanup',
      },
    },
    config = function()
      require('config.plugins.refactoring')
    end,
  },
  {
    'stevearc/conform.nvim',
    keys = {
      {
        ',f',
        function()
          require('conform').format({
            lsp_format = 'never',
          })
        end,
        desc = 'Format current file',
      },
    },
    config = function()
      require('config.plugins.conform')
    end,
  },
  {
    'tpope/vim-dadbod',
    ft = { 'sql', 'mysql', 'plsql' },
    cmd = { 'DB', 'DBUI', 'DBUIToggle', 'DBUIAddConnection', 'DBUIFindBuffer', 'DBUIRenameBuffer' },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kristijanhusak/vim-dadbod-ui',
      'kristijanhusak/vim-dadbod-completion',
    },
    config = function()
      require('config.plugins.dadbod').setup()
    end,
  },
}
