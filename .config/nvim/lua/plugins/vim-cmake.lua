return {
  'cdelledonne/vim-cmake',
  config = function() vim.cmd([[let g:cmake_build_dir_location = 'build']]) end,
}
