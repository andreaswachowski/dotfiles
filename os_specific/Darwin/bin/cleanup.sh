#!/bin/bash
# vi: tw=0
/usr/bin/find $HOME/{Downloads,books,mendeley_inbox,tmp,.tmux/resurrect} -mount -ctime +30 -mindepth 1 -delete
/usr/bin/find $HOME/Desktop -name 'Screen Shot *' -mount -ctime +60 -mindepth 1 -delete
