local dap = require("dap")

-- Set tmux as the external terminal for debuggin
dap.defaults.fallback.external_terminal = {
    command = "tmux",
    args = { "new-window", "-t", "work:6", "-n", "debug" }
}

vim.g.dap_open_float = false;
-- local ENV = os.getenv("VIRTUAL_ENV")
-- local function isempty(s)
--     return s == nil or s == ''
-- end

dap.adapters.python = {
  type = 'executable',
  command = '/home/lukas/Development/venvs/debugpy/bin/python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 12',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/venvs/odoo12/bin/python",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo12.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "internalConsole",
    -- console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 13',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/odev/venvs/odoo13/bin/python3",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo-server-13.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 14',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/venvs/odoo14/bin/python3",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo14.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    -- console = "internalConsole",
    -- console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 12 Test',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/odev/venv/odoo-12/bin/python3",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo-server-12.conf',
            '--test-enable',
            '--log-level=test',
            '--limit-time-real=10000000',
    },
    cwd = '${workspaceFolder}',
    console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 14 Test',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/odev/venv/odoo-14/bin/python3",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo-server-14.conf',
            '--test-enable',
            '--log-level=test',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Runbot 14',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/lukas/Development/odev/venv/runbot14/bin/python3",
    args = {
            '--config=/home/lukas/Development/odev/configs/odoo-server-14-runbot.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "externalTerminal",
  },
  {
    type = 'python',
    request = 'launch',
    name = 'Odoo 18',
    program = '/home/lukas/Development/odev/odoo/odoo-bin',
    pythonPath = "/home/xenophon/Development/Personal/venv/odoo-18/bin/python3",
    args = {
            '--config=/home/xenophon/Development/Personal/configs/odoo-server-18.conf',
            '--limit-time-real=10000000',
    }, -- Adjust arguments as needed
    cwd = '${workspaceFolder}',
    console = "externalTerminal",
  },
}
dap.set_log_level('DEBUG')
