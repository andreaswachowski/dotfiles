-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
-- Add any additional override configuration in a file lsp/settings/<lspserver_name>.lua.
-- This would take the form of
--
--   return {
--      settings = {
--        ...
--      },
--      ... -- on_attach, capabilities, filetypes, ...
--   }
--  the `settings` field of the server config. You must look up that documentation yourself.
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.

local servers = {
  'ansiblels',
  'bashls',
  -- To get clang-tidy diagnostics, add the following to your project root:
  -- https://github.com/cpp-best-practices/gui_starter_template/blob/main/.clang-tidy
  -- (cf.
  -- https://github.com/williamboman/nvim-lsp-installer/discussions/392#discussioncomment-2347401)
  'clangd',
  -- gopls = {},
  'html',
  'jsonls',
  'lua_ls',
  'ruby_lsp',
  'pyright',
  -- rust_analyzer = {},
  'tsserver',
  'yamlls',
}

-- Setup neovim lua configuration
require('neodev').setup({
  library = { plugins = { 'nvim-dap-ui' }, types = true },
})

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = servers,
})

local default_handler = function(server)
  require('lspconfig')[server].setup({
    capabilities = require('lsp.handlers').capabilities,
    on_attach = require('lsp.handlers').on_attach,
    filetypes = (servers[server] or {}).filetypes,
  })
end

local lsp_handlers = {
  default_handler,
}

local build_lsp_configs = function()
  for _, server in pairs(servers) do
    local opts = {
      on_attach = require('lsp.handlers').on_attach,
      capabilities = require('lsp.handlers').capabilities,
    }

    server = vim.split(server, '@')[1]

    local require_ok, conf_opts = pcall(require, 'lsp.settings.' .. server)
    if require_ok then
      opts = vim.tbl_deep_extend('force', conf_opts, opts)
      local new_handler = function() require('lspconfig')[server].setup(opts) end
      lsp_handlers = vim.tbl_deep_extend('force', lsp_handlers, { [server] = new_handler })
    end
  end
  return lsp_handlers
end

mason_lspconfig.setup_handlers(build_lsp_configs())
