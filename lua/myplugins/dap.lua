local status, dap = pcall(require, 'dap')
if not status then
  return
end

-- NOTE: CodeLLDB adapter for Rust is configured in rustaceanvim.lua
-- Rustaceanvim handles its own DAP setup with get_codelldb_adapter()
-- Do not configure dap.adapters.codelldb here to avoid conflicts

-- Simple argument prompting for Rust debugging
local original_run = dap.run
dap.run = function(config)
  if config.type == 'codelldb' and (not config.args or #config.args == 0) then
    local args_string = vim.fn.input('Program arguments: ')
    if args_string ~= '' then
      -- Parse arguments: split by space, but respect quotes
      local args = {}
      local current_arg = ''
      local in_quotes = false

      for i = 1, #args_string do
        local char = args_string:sub(i, i)
        if char == '"' then
          in_quotes = not in_quotes
        elseif char == ' ' and not in_quotes then
          if current_arg ~= '' then
            table.insert(args, current_arg)
            current_arg = ''
          end
        else
          current_arg = current_arg .. char
        end
      end

      if current_arg ~= '' then
        table.insert(args, current_arg)
      end

      config.args = args
    else
      config.args = {}
    end
  end
  original_run(config)
end

dap.adapters.nlua = function(callback, _)
  callback({ type = 'server', host = '127.0.0.1', port = 8086 })
end
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}

local ok, dapui = pcall(require, 'dapui')
if not ok then
  return
end

dapui.setup()
--
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local js_debug_paths = {
  '/Users/shaun.wen/repo/github/vscode-js-debug',
  vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter',
}

local debugger_path
for _, path in ipairs(js_debug_paths) do
  if vim.uv.fs_stat(path) then
    debugger_path = path
    break
  end
end

if debugger_path then
  require('dap-vscode-js').setup({
    adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
    debugger_path = debugger_path,
  })
end

for _, language in ipairs({ 'typescript', 'javascript' }) do
  dap.configurations[language] = {
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Launch file',
      program = '${file}',
      cwd = '${workspaceFolder}',
      sourceMaps = true,
      skipFiles = { '<node_internals>/**', 'node_modules/**' },
    },
    {
      type = 'pwa-node',
      request = 'attach',
      name = 'Attach',
      processId = require 'dap.utils'.pick_process,
      cwd = '${workspaceFolder}',
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug Jest Tests',
      trace = true, -- include debugger info
      runtimeExecutable = 'node',
      runtimeArgs = {
        './node_modules/.bin/jest',
        '--config jest.unit.config.js',
        '--runInBand',
      },
      program = '${file}',
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      -- sourceMaps = true,
      console = 'integratedTerminal',
      protocol = 'inspector',
      internalConsoleOptions = 'neverOpen',
      -- https://www.reddit.com/r/neovim/comments/y7dvva/typescript_debugging_in_neovim_with_nvimdap/
    },
    {
      type = 'pwa-node',
      request = 'launch',
      name = 'Debug Mocha Tests',
      -- trace = true, -- include debugger info
      runtimeExecutable = 'node',
      runtimeArgs = {
        './node_modules/mocha/bin/mocha.js',
      },
      rootPath = '${workspaceFolder}',
      cwd = '${workspaceFolder}',
      console = 'integratedTerminal',
      internalConsoleOptions = 'neverOpen',
    },
  }
end
