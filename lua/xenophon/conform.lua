require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    -- Conform will run multiple formatters sequentially
    python = { "autopep8" },
    -- You can customize some of the format options for the filetype (:help conform.format)
    rust = { "rustfmt", lsp_format = "fallback" },
    -- Conform will run the first available formatter
    javascript = { "prettier" },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  },
  formatters = {
      autopep8 = {
          prepend_args = { "--max-line-length", "240" },
      },
      prettier = {
          prepend_args = { "--tab-width", "2", "--trailing-comma", "es5" , "--end-of-line", "lf", "--semi", false, "--single-quote", false },
      },
  }
})
