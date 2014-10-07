let g:syntastic_mode_map = { "mode": "active", "passive_filetypes": ["c", "cpp"] }

if hostname() =~ "mac*"
  let g:syntastic_cpp_compiler = "g++-4.9"
endif

let g:syntastic_cpp_compiler_options = "-std=c++11"
