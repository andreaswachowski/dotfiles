-- [[ Ruby LSP Configuration }]
-- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#neovim-lsp

-- textDocument/diagnostic support until 0.10.0 is released
---@diagnostic disable-next-line: lowercase-global
_timers = {}

local log = require('vim.lsp.log')

local function setup_diagnostics(client, buffer)
  if require('vim.lsp.diagnostic')._enable then return end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request('textDocument/diagnostic', { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format('diagnostics error - %s', vim.inspect(err))
        log.error(err_msg)
      end
      local diagnostic_items = {}
      if result then diagnostic_items = result.items end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend('keep', params, { diagnostics = diagnostic_items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then vim.fn.timer_stop(_timers[buffer]) end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then vim.fn.timer_stop(_timers[buffer]) end
    end,
  })
end

-- adds ShowRubyDeps command to show dependencies in the quickfix list.
-- add the `all` argument to show indirect dependencies as well
local function add_ruby_deps_command(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'ShowRubyDeps', function(opts)
    local params = vim.lsp.util.make_text_document_params()

    local showAll = opts.args == 'all'

    client.request('rubyLsp/workspace/dependencies', params, function(error, result)
      if error then
        print('Error showing deps: ' .. error)
        return
      end

      local qf_list = {}
      for _, item in ipairs(result) do
        if showAll or item.dependency then
          table.insert(qf_list, {
            text = string.format('%s (%s) - %s', item.name, item.version, item.dependency),

            filename = item.path,
          })
        end
      end

      vim.fn.setqflist(qf_list)
      vim.cmd('copen')
    end, bufnr)
  end, { nargs = '?', complete = function() return { 'all' } end })
end

return {
  -- https://github.com/Shopify/ruby-lsp/issues/1198#issuecomment-1946436302
  -- Debug with "lua =vim.lsp.get_clients()[1].config.init_options"
  init_options = { formatter = 'rubocop' },
  cmd = { vim.fn.expand('$HOME/.rbenv/shims/ruby-lsp') },
  -- We want both the diagnostics (for the code actions)
  -- and the keyboard shortcuts from the general setup,
  -- so combine them into one function
  on_attach = function(client, bufnr)
    setup_diagnostics(client, bufnr)
    add_ruby_deps_command(client, bufnr)
    require('lsp.handlers').on_attach(client, bufnr)
  end,
}
