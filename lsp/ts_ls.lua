-- return {
--     root_dir = "/home/lukas/Development/"
-- }
-- TypeScript/JavaScript LSP (typescript-language-server)
-- Place this file at: ~/.config/nvim/lsp/ts_ls.lua
-- Then enable it with:  :lua vim.lsp.enable('ts_ls')

return {
  -- typescript-language-server command
  cmd = { 'typescript-language-server', '--stdio' },

  -- Attach to TS/JS buffers
  filetypes = {
    'javascript', 'javascriptreact', 'javascript.jsx',
    'typescript', 'typescriptreact', 'typescript.tsx',
  },

  -- Let it work on single files too (outside a project)
  single_file_support = true,

  -- Root detection without depending on lspconfig.util
  -- (Nvim 0.11+ supports root_markers in vim.lsp.config)
  root_markers = { { 'tsconfig.json', 'jsconfig.json', 'package.json' }, '.git' },

  -- Initialization options for typescript-language-server
  -- (hostInfo helps the server detect Neovim)
  init_options = {
    hostInfo = 'neovim',
    preferences = {
      includeCompletionsForImportStatements = true,
      includeCompletionsForModuleExports = true,
      importModuleSpecifierPreference = 'shortest',
      includePackageJsonAutoImports = 'auto',
    },
    tsserver = {
      -- 'auto' launches a light syntax server for quick diagnostics while the
      -- project server warms up
      useSyntaxServer = 'auto',
    },
    -- You can tweak tsserver "preferences" here as well if you like
    -- preferences = { quotePreference = 'single' },
  },

  -- Settings sent via workspace/didChangeConfiguration.
  -- This is where we enable/shape “built-in linting” (diagnostics) behavior.
  -- See the upstream config reference for supported keys.
  settings = {
    -- Diagnostics: don't ignore any codes (i.e., show everything tsserver reports)
    diagnostics = { ignoredCodes = {} },

    -- Make TS/JS completions insert full function calls when appropriate
    completions = { completeFunctionCalls = true },

    -- Typescript-specific editor prefs (mirrored for javascript below)
    typescript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        includeInlayParameterNameHints = 'literals',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      -- Optional: formatter preferences (uncomment if you want tsserver formatting)
      -- format = { semicolons = 'insert' },
    },

    javascript = {
      suggest = { completeFunctionCalls = true },
      inlayHints = {
        includeInlayParameterNameHints = 'literals',
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      -- format = { semicolons = 'insert' },
    },

    -- How tsserver treats single-file buffers outside a project
    implicitProjectConfiguration = {
      checkJs = false,          -- set true if you want TS to type-check plain JS files
      strictNullChecks = true,
      strictFunctionTypes = true,
      target = 'ES2020',
    },
  },

  -- Buffer-local customizations once the client is attached
  on_attach = function(client, bufnr)
    -- Neovim's diagnostics are on by default, but let's tune the UI a bit
    -- so “linting” (diagnostics) is pleasant to read.
    vim.diagnostic.config({
      underline = true,
      severity_sort = true,
      update_in_insert = false,
      virtual_text = { spacing = 2, source = 'if_many' },
      signs = true,
    })

    -- Optional: Enable inlay hints if your Neovim has the API
    if vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint, bufnr, true)
    end

    -- OPTIONAL: Auto “Fix all / Organize imports” on save.
    -- Comment this block out if you prefer manual control.
    -- Note: this applies only to the current buffer’s LSP client.
    -- vim.api.nvim_create_autocmd('BufWritePre', {
    --   buffer = bufnr,
    --   callback = function()
    --     local ok = pcall(vim.lsp.buf.code_action, {
    --       apply = true,
    --       context = {
    --         only = {
    --           'source.fixAll.ts',
    --           'source.addMissingImports.ts',
    --           'source.removeUnused.ts',
    --           'source.organizeImports',
    --         },
    --       },
    --     })
    --     -- it's fine if no code action is available
    --     if not ok then return end
    --   end,
    --   desc = 'ts_ls: Fix all / Organize imports on save',
    -- })
  end,
}
