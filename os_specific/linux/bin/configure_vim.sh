#!/bin/bash
export CFLAGS="-g"
export CPPFLAGS="-g"
export CXXFLAGS="-g"
# export CC=/usr/bin/llvm-gcc
# export CXX=/usr/bin/llvm-g++
# export OBJC=/usr/bin/llvm-gcc

# Need to source rvm functionality, otherwise it will quit saying it needs to
# run through a login shell
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Python is needed for Valloric/YouCompleteMe
#
# Need to disable GUI on Mac
#
# YouCompleteMe will crash on Ruby completion unless I use the system provided Ruby library
# perhaps because
# a) YCM is compiled against that (I don't see it though)
# b) vim is statically binding the rvm-lib and therefore the call to load a lib fails
#
#	In other words, I cannot use the RVM-provided Ruby:
# --with-ruby-command=/Users/andreas/.rvm/rubies/ruby-2.2.3/bin/ruby \
# See https://www.andreas-wachowski.de/wordpress/?p=815

# rvm use system # make sure the system-default Ruby is enabled

make distclean
./configure --prefix=$HOME/local \
	--enable-gui=no \
	--enable-multibyte \
	--enable-rubyinterp \
	--with-client-server \
	--enable-pythoninterp
# rvm use default # switch back to desired Ruby
