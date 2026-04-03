return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('config.plugins.onedark')
    end,
  },
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('config.plugins.devicons')
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.plugins.lualine')
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    main = 'ibl',
    config = function()
      require('config.plugins.indent-blankline')
    end,
  },
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },
  {
    'folke/snacks.nvim',
    event = 'VeryLazy',
    config = function()
      require('config.plugins.snacks')
    end,
  },
}
