local dap = require('dap')
-- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#ccrust-via-lldb-vscode
dap.adapters.lldb = {
  type = 'executable',
  command = '/opt/homebrew/bin/lldb-vscode',
  name = 'lldb',
}
dap.configurations.cpp = {
  {
    -- https://github.com/llvm/llvm-project/tree/main/lldb/tools/lldb-vscode#configurations
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},

    -- 💀
    -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --
    --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --
    -- Otherwise you might get the following error:
    --
    --    Error on launch: Failed to attach to the target process
    --
    -- But you should be aware of the implications:
    -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html

    -- run in terminal to accept standard input
    runInTerminal = true,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require('dapui').setup()
require('nvim-dap-virtual-text').setup()
require('telescope').load_extension('dap')

local dapui = require('dapui')
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.after.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.after.event_exited['dapui_config'] = function()
  dapui.close()
end
