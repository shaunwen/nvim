vim.g.rustaceanvim = {
  server = {
    settings = {
      ['rust-analyzer'] = {
        check = { command = 'clippy' },
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
}
