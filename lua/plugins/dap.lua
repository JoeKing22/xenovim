return {
    "mfussenegger/nvim-dap-python",
    dependencies = {
        { "nvim-neotest/nvim-nio" },
        { "mfussenegger/nvim-dap" },
        { "rcarriga/nvim-dap-ui" },
    },
    config = function()
        require('dap-python').setup('/home/lukas/Development/venvs/debugpy/bin/python')
    end,
}
