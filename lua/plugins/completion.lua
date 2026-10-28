return {
  {
    'onsails/lspkind-nvim',
    config = function()
      require('config.plugins.lspkind')
    end,
  },
  {
    'L3MON4D3/LuaSnip',
    event = 'InsertEnter',
    dependencies = {
      'rafamadriz/friendly-snippets',
    },
    config = function()
      require('config.plugins.luasnip')
    end,
  },
  {
    'saghen/blink.cmp',
    event = 'InsertEnter',
    version = '1.*',
    dependencies = {
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('config.plugins.blink-cmp')
    end,
  },
}
