local status, dap = pcall(require, 'dap')
if (not status) then return end

dap.adapters.codelldb = {
  type = 'executable',
  command = '/Users/shaun.wen/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/adapter/codelldb', -- adjust as needed, must be absolute path
  -- command = '/Users/shaun.wen/.vscode/extensions/vadimcn.vscode-lldb-1.8.1/lldb/bin/lldb', -- adjust as needed, must be absolute path
  name = 'rt_lldb'
}
dap.configurations.rust = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.adapters.nlua = function(callback, _)
  callback({ type = 'server', host = "127.0.0.1", port = 8086 })
end
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = "Attach to running Neovim instance",
  }
}



local ok, dapui = pcall(require, "dapui")
if (not ok) then return end

dapui.setup()
--
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open({})
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close({})
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close({})
end

require("dap-vscode-js").setup({
  -- debugger_path = vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
  debugger_path = '/Users/shaun.wen/repo/github/vscode-js-debug',
  -- debugger_cmd = { 'js-debug-adapter' },
  adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
  -- node_path = os.getenv('HOME') .. '/.nvm/versions/node/v16.14.2/bin/node',
})

for _, language in ipairs({ "typescript", "javascript" }) do
  dap.configurations[language] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = require 'dap.utils'.pick_process,
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/.bin/jest",
        "--config jest.unit.config.js",
        "--runInBand",
      },
      program = "${file}",
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      -- sourceMaps = true,
      console = "integratedTerminal",
      protocol = "inspector",
      internalConsoleOptions = "neverOpen",
      -- https://www.reddit.com/r/neovim/comments/y7dvva/typescript_debugging_in_neovim_with_nvimdap/
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Mocha Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/mocha/bin/mocha.js",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    }
  }
end
