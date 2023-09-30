-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  local function quickfix()
    vim.lsp.buf.code_action({
      filter = function(a)
        return a.isPreferred
      end,
      apply = true,
    })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('<leader>qf', quickfix, '[Q]uick[f]ix (apply code action)')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap(
    'gI',
    require('telescope.builtin').lsp_implementations,
    '[G]oto [I]mplementation'
  )
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap(
    '<leader>ds',
    require('telescope.builtin').lsp_document_symbols,
    '[D]ocument [S]ymbols'
  )
  nmap(
    '<leader>ws',
    require('telescope.builtin').lsp_dynamic_workspace_symbols,
    '[W]orkspace [S]ymbols'
  )

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- TODO: <C-k> conflicts with window navigation
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap(
    '<leader>wa',
    vim.lsp.buf.add_workspace_folder,
    '[W]orkspace [A]dd Folder'
  )
  nmap(
    '<leader>wr',
    vim.lsp.buf.remove_workspace_folder,
    '[W]orkspace [R]emove Folder'
  )
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
end

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
  'ruby_ls',
  'pyright',
  -- rust_analyzer = {},
  'tsserver',
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require('mason-lspconfig')

mason_lspconfig.setup({
  ensure_installed = servers,
})

local default_handler = function(server)
  require('lspconfig')[server].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = (servers[server] or {}).filetypes,
  })
end

local lsp_handlers = {
  default_handler,
}

local build_lsp_configs = function()
  for _, server in pairs(servers) do
    local opts = {
      on_attach = on_attach,
      capabilities = capabilities,
    }

    server = vim.split(server, '@')[1]

    local require_ok, conf_opts = pcall(require, 'lsp.settings.' .. server)
    if require_ok then
      opts = vim.tbl_deep_extend('force', conf_opts, opts)
      local new_handler = function()
        require('lspconfig')[server].setup(opts)
      end
      lsp_handlers =
        vim.tbl_deep_extend('force', lsp_handlers, { [server] = new_handler })
    end
  end
  return lsp_handlers
end

mason_lspconfig.setup_handlers(build_lsp_configs())

-- [[ Ruby LSP Configuration }]
-- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#neovim-lsp

-- textDocument/diagnostic support until 0.10.0 is released
---@diagnostic disable-next-line: lowercase-global
_timers = {}
local function setup_diagnostics(client, buffer)
  if require('vim.lsp.diagnostic')._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request(
      'textDocument/diagnostic',
      { textDocument = params },
      function(err, result)
        if err then
          local err_msg =
            string.format('diagnostics error - %s', vim.inspect(err))
          vim.lsp.log.error(err_msg)
        end
        if not result then
          return
        end
        vim.lsp.diagnostic.on_publish_diagnostics(
          nil,
          vim.tbl_extend('keep', params, { diagnostics = result.items }),
          { client_id = client.id }
        )
      end
    )
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })
end

require('lspconfig').ruby_ls.setup({
  -- We want both the diagnostics (for the code actions)
  -- and the keyboard shortcuts from the general setup,
  -- so combine them into one function
  on_attach = function(client, bufnr)
    setup_diagnostics(client, bufnr)
    on_attach(client, bufnr)
  end,
})
