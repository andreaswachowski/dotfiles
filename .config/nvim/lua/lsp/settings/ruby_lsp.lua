-- https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md#neovim-lsp

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
  cmd = { 'mise', 'exec', '--', 'ruby-lsp' },
  -- We want both the diagnostics (for the code actions)
  -- and the keyboard shortcuts from the general setup,
  -- so combine them into one function
  on_attach = function(client, bufnr)
    add_ruby_deps_command(client, bufnr)
    require('lsp.handlers').on_attach(client, bufnr)
  end,
}
