if exists("b:current_syntax")
    finish
endif

" Define the patterns for paths you want to conceal
let s:home = expand('$HOME')
let s:work_path = s:home . '/Documents/git_projects/work'
let s:escaped_work = escape(s:work_path, '/.')

" Create a pattern for the gem path that's flexible enough to match variations
" This will match paths like ~/.mise/...bundle/ruby/VERSION/gems or similar patterns
let s:gem_pattern = s:home . '/.local/share/mise/installs/ruby/[0-9.]\+/lib/ruby/gems/[0-9.]\+'
let s:ruby_lib_pattern = s:home . '/.local/share/mise/installs/ruby/[0-9.]\+\(/lib/ruby/[0-9.]\+\)\@='
let s:ruby_bin_pattern = s:home . '/.local/share/mise/installs/ruby/[0-9.]\+\(/bin/\)\@='

" Define the syntax matches for both patterns
" Work project path
" execute 'syntax match workDir "' . s:escaped_work . '[/\\]" conceal cchar=@'
execute 'syntax match workDir "' . s:escaped_work . '" conceal cchar=@'

" Gem path
execute 'syntax match gemsDir "' . escape(s:gem_pattern, '/.')  . '" conceal cchar=⭑'

execute 'syntax match rubyLibDir "' . escape(s:ruby_lib_pattern, '/.')  . '" conceal cchar=⭑'

execute 'syntax match rubyBinDir "' . escape(s:ruby_bin_pattern, '/.')  . '" conceal cchar=⭑'

" Set up concealment
setlocal conceallevel=2
setlocal concealcursor=nvic

" Make sure the filepath is still treated as a filepath for gf
syntax match rubyFilePath "[/\\]\f*" contains=workDir,gemsDir,rubyLibDir,rubyBinDir

" Define highlighting
highlight link rubyFilePath Directory
highlight link workDir Conceal
highlight link gemsDir Conceal
highlight link rubyLibDir Conceal
highlight link rubyBinDir Conceal

" Use different colors for different concealed paths
highlight Conceal ctermfg=blue guifg=blue

let b:current_syntax = "ruby_stacktrace"
