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
    })
  end,
}
