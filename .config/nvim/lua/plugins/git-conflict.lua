return {
  'akinsho/git-conflict.nvim',
  version = '*',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('git-conflict').setup({
      default_mappings = {
        ours = 'co',
        theirs = 'ct',
        none = 'c0',
        both = 'cb',
        next = ']x', -- plugin default (but non-idiomatic): [x
        prev = '[x', -- plugin default (but non-idiomatic): ]x
      },
      highlights = {
        -- https://github.com/ellisonleao/gruvbox.nvim/discussions/239#discussioncomment-7154441
        -- https://github.com/akinsho/git-conflict.nvim/issues/72#issuecomment-1774546983
        current = 'DiffDelete', -- 'DiffText'
        incoming = 'DiffAdd',
        ancestor = nil,
      },
    })
  end,
}
