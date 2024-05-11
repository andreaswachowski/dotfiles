local org_path = function(path)
  local org_directory = '~/Documents/git_projects/notes'
  return ('%s/%s'):format(org_directory, path)
end

return {
  'nvim-orgmode/orgmode',
  event = 'VeryLazy',
  ft = { 'org', 'orgagenda' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = { org_path('**/*.org'), org_path('**/*.org_archive') },
      org_default_notes_file = org_path('refile.org'),
      org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'PROGRESS(p)', '|', 'DONE(d)', 'CANCELLED(c)' },
      org_capture_templates = {
        t = {
          description = 'Refile',
          template = '* TODO %?\nCREATED: %U',
        },
        n = {
          description = 'Note',
          template = '* %?\nCREATED: %U',
        },
      },
    })

    -- NOTE: If you are using nvim-treesitter with `ensure_installed = "all"` option
    -- add `org` to ignore_install
    -- require('nvim-treesitter.configs').setup({
    --   ensure_installed = 'all',
    --   ignore_install = { 'org' },
    -- })
  end,
}
