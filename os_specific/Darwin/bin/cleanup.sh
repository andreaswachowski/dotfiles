#!/bin/bash
# vi: tw=0

# vim-swap files in ~/tmp/vim are exculded from the cleanup, because theoretically,
# vim swapfiles that are still in use would be deleted if that vim-session were
# running longer than 30 days.
/usr/bin/find $HOME/{.Trash,Downloads,books,mendeley_inbox,tmp,.tmux/resurrect} -mount \
  -ctime +30 -mindepth 1 ! -name '$HOME/tmp/vim/*' -delete
/usr/bin/find $HOME/Desktop -name 'Screen Shot *' -mount \
  -ctime +60 -mindepth 1 -delete
