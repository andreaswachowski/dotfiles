# vi: filetype=sh
# https://github.com/Salzig/.files/blob/master/home/.bash_functions
togif() {
  ffmpeg -i "$1" -pix_fmt rgb24 -r 10 ${1%.*}.gif
}

# http://superuser.com/questions/246967/tmux-insert-a-window-at-a-specified-position?rq=1
#ins-move() {
#  if [ "$1" -lt "$2" ] ; then
#    WINDOW_TO_MOVE=$1
#    MOVE_BEFORE_POS=$2
#  else
#    WINDOW_TO_MOVE=$2
#    MOVE_BEFORE_POS=$1
#  fi
#  for ((i=$WINDOW_TO_MOVE; i<$MOVE_BEFORE_POS-1; i++))
#    do
#      tmux swap-window -s :$i -t :$((i+1))
#        done
#}

lint-stats() {
  linter=$1 # linter is tested with 'haml' and 'scss'
  dir=$2 # possibly empty
  $linter-lint $2 | awk '{ print $3 }' | sort | uniq -c | sort -n
}

scss-lint-stats() {
  lint-stats scss
}

# http://stackoverflow.com/questions/18364146/show-all-commits-whose-diff-contain-specific-string
git-commits-containing-pattern() {
  git rev-list HEAD | while read rev; do   if git show -p $rev | grep "$1" >/dev/null; then echo $rev; fi; done
}

browser-sync-rails() {
  # browser-sync start --proxy="localhost:3000" --files="app/assets/stylesheets/**/*.css, app/assets/stylesheets/**/*.scss, app/assets/javascripts/**/*.coffee, app/assets/javascripts/**/*.js, app/views/**/*.html.erb, app/views/**/*.haml"
  # only watch generated files
  browser-sync start --proxy="localhost:3000" --files="app/assets/stylesheets/**/*.css,  app/assets/javascripts/**/*.js, app/views/**/*.haml"
}

git-remove-merged() {
  # http://devblog.springest.com/a-script-to-remove-old-git-branches
  git branch --merged develop | grep -v 'develop$' | grep -v 'master$' | xargs git branch -d
}

git-most-changed() {
  # Show the most often changed files in a git repo
  # See http://stackoverflow.com/questions/7686582/finding-most-changed-files-in-git

  NO=$1

  if [ -z "$NO" ]; then
    NO=10
  fi

  git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -$NO
}

which-process-on-port() {
  lsof -n -i4TCP:$1 -i6TCP:$1
}
