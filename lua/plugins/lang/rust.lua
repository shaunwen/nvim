return {
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    ft = { 'rust' },
    init = function()
      require('config.plugins.rustaceanvim')
    end,
    keys = {
      { '<Leader>rr', '<cmd>RustLsp runnables<CR>', desc = 'Rust runnables' },
      { '<Leader>rd', '<cmd>RustLsp debuggables<CR>', desc = 'Rust debuggables' },
    },
  },
}
