require('lint').linters_by_ft = {
  python = {'flake8'},
  javascript = {'eslint'},
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    require("lint").try_lint("cspell")
  end,
})

local flake8_args = require('lint').linters.flake8.args
table.insert(flake8_args,2,'--max-line-length')
table.insert(flake8_args,3,'240')

local cspell_args = require('lint').linters.cspell.args
table.insert(cspell_args,2,'--config')
table.insert(cspell_args,3,'~/.config/nvim/cspell.json')
