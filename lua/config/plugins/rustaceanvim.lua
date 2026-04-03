local codelldb_path = vim.fn.stdpath('data')
  .. '/mason/packages/codelldb/extension/adapter/codelldb'
local liblldb_path = vim.fn.stdpath('data')
  .. '/mason/packages/codelldb/extension/lldb/lib/liblldb.dylib'

vim.g.rustaceanvim = function()
  local cfg = require('rustaceanvim.config')
  return {
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
    dap = {
      adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
    },
  }
end
