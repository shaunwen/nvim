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
-- dap.configurations.rust = dap.configurations.cpp


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
  dapui.toggle({})
end
