return {
  {
    'mfussenegger/nvim-dap',
    keys = {
      {
        '<Leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'DAP toggle breakpoint',
      },
      {
        '<F9>',
        function()
          require('dap').continue()
        end,
        desc = 'DAP continue',
      },
      {
        '<Leader>do',
        function()
          require('dapui').open()
        end,
        desc = 'DAP UI open',
      },
      {
        '<Leader>dO',
        function()
          require('dapui').close()
        end,
        desc = 'DAP UI close',
      },
      {
        '<Leader>dt',
        function()
          require('dapui').toggle()
        end,
        desc = 'DAP UI toggle',
      },
      {
        '<F8>',
        function()
          require('dap').step_over()
        end,
        desc = 'DAP step over',
      },
      {
        '<F7>',
        function()
          require('dap').step_into()
        end,
        desc = 'DAP step into',
      },
      {
        '<F12>',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'DAP hover',
      },
      {
        '<F5>',
        function()
          require('osv').launch({ port = 8086 })
        end,
        desc = 'Launch OSV',
      },
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          'nvim-neotest/nvim-nio',
        },
      },
      'mxsdev/nvim-dap-vscode-js',
      'jbyuki/one-small-step-for-vimkind',
    },
    config = function()
      require('config.plugins.dap').setup()
    end,
  },
}
