let b:ale_fixers = { 'python': ['black', 'isort'] }
let b:ale_fix_on_save = 1
autocmd BufEnter notebooks/**/*.py let b:ale_fixers = { 'python': [] }
