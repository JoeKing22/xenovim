-- For ruff (in the cmd venv) pip3 install 'python-lsp-server[all]' ruff python-lsp-ruff
return {
    cmd = { '/home/lukas/Development/venvs/debugpy/bin/pylsp' },
    filetypes = { 'python' },
    settings = {
        pylsp = {
            -- configurationSources = { 'ruff' },
            plugins = {
                flake8 = {
                    enabled = false,
                    ignore = { 'E501', 'E231' },
                    maxLineLength = 88,
                },
                black = {enabled = false},
                autopep8 = { enabled = false },
                ruff = { 
                    enabled = true,
                },
                mccabe = {enabled = false},
                pycodestyle = {
                    enabled = false,
                    ignore = { 'E501', 'E231' },
                    maxLineLength = 88,
                },
                pyflakes = {enabled = false},
                jedi_completion = {
                    include_params = true,
                },
                jedi_signature_help = {enabled = false},
                jedi = {
                    extra_paths = {
                        '/home/lukas/Development/odev/',
                        '/home/lukas/Development/odev/odoo/',
                        '/home/lukas/Development/odev/taskflow/',
                        '/home/lukas/Development/odev/taskflow-config/'
                    },
                },
            },
        },
    },
    root_markers = {
        '.git',
        'setup.py',
        'pyproject.toml',
        'requirements.txt',
    },
    -- root_dir = "/home/lukas/Development/",
}
