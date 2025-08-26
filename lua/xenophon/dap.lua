local dap = require("dap")
vim.g.dap_open_float = false;
-- local ENV = os.getenv("VIRTUAL_ENV")
-- local function isempty(s)
--     return s == nil or s == ''
-- end

dap.adapters.python = {
  type = 'executable',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 12',
    program = '/home/lukas/Development/odoo-dev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/py3717/bin/python",
    args = {
            '--config=/home/lukas/Development/odoo-dev/odoo12.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "internalConsole",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 14',
    program = '/home/lukas/Development/odoo-dev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/py3717/bin/python",
    args = {
            '--config=/home/lukas/Development/odoo-dev/odoo14.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "internalConsole",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 12 Test',
    program = '/home/lukas/Development/TaskFlow/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/TaskFlow/venv/odoo-12/bin/python3",
    args = {
            '--config=/home/lukas/Development/TaskFlow/configs/odoo-server-12.conf',
            '--test-enable',
            '--log-level=test',
            '--limit-time-real=10000000',
    },
    cwd = '${workspaceFolder}',
    console = "internalConsole",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 14 Test',
    program = '/home/lukas/Development/TaskFlow/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/TaskFlow/venv/odoo-14/bin/python3",
    args = {
            '--config=/home/lukas/Development/TaskFlow/configs/odoo-server-14.conf',
            '--test-enable',
            '--log-level=test',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "internalConsole",
  },
}
dap.set_log_level('DEBUG')
