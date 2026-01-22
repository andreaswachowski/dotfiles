local org_path = function(path)
  local org_directory = '~/Documents/git_projects/notes'
  return ('%s/%s'):format(org_directory, path)
end

return {
  'nvim-orgmode/orgmode',
  -- 'andreaswachowski/orgmode',
  -- dir = '~/Documents/git_projects/orgmode',
  event = 'VeryLazy',
  ft = { 'org', 'orgagenda' },
  config = function()
    -- Setup orgmode
    require('orgmode').setup({
      org_agenda_files = { org_path('**/*.org'), org_path('**/*.org_archive') },
      org_default_notes_file = org_path('refile.org'),
      org_todo_keywords = { 'TODO(t)', 'NEXT(n)', 'PROGRESS(p)', '|', 'DONE(d)', 'CANCELLED(c)' },
      org_capture_templates = {
        s = {
          description = 'Sysadmin Log',
          template = '* %?\n  CREATED: %U',
          target = org_path('logs/sysadmin_log.org'),
          datetree = {
            tree_type = 'month',
          },
        },
        f = {
          description = 'Friction Log',
          template = '* %?\n  CREATED: %U',
          target = org_path('logs/friction_log.org'),
          datetree = {
            tree_type = 'month',
          },
        },
        i = {
          description = 'Finance Log',
          template = '* %?\n  CREATED: %U',
          target = org_path('logs/finance_log.org'),
          datetree = {
            tree_type = 'month',
          },
        },
        t = {
          description = 'Refile',
          template = '* TODO %?\n  CREATED: %U',
        },
        n = {
          description = 'Note',
          template = '* %?\n  CREATED: %U',
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
