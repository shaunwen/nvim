return {
  {
    'akinsho/toggleterm.nvim',
    cmd = { 'ToggleTerm', 'TermExec' },
    keys = {
      {
        '<leader>tt',
        function()
          require('config.plugins.toggleterm').toggle_float()
        end,
        desc = 'Toggle floating terminal',
      },
      {
        '<leader>ui',
        function()
          require('config.plugins.toggleterm').toggle_gitui()
        end,
        desc = 'Toggle gitui terminal',
      },
      {
        '<leader>py',
        function()
          require('config.plugins.toggleterm').toggle_python()
        end,
        desc = 'Toggle python terminal',
      },
      {
        '<leader>ts',
        function()
          require('config.plugins.toggleterm').toggle_horizontal()
        end,
        desc = 'Toggle horizontal terminal',
      },
      {
        '<leader>tv',
        function()
          require('config.plugins.toggleterm').toggle_vertical()
        end,
        desc = 'Toggle vertical terminal',
      },
    },
    config = function()
      require('config.plugins.toggleterm').setup()
    end,
  },
}
