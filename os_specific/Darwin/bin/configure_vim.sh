#!/bin/bash
export CFLAGS="-g"
export CPPFLAGS="-g"
export CXXFLAGS="-g"
export CC=/usr/bin/llvm-gcc
export CXX=/usr/bin/llvm-g++
export OBJC=/usr/bin/llvm-gcc

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

rvm use system # make sure the system-default Ruby is enabled

# Same problem with Python: If vim is compiled against the anaconda-installed Python
# and YouCompleteMe against a different version, then vim crashes on startup.
# (and with ultisnips, vim crashes when switching to insert mode)

printf "Make sure Python is installed via brew, and that this package and not Xcode's Python is linked. Python to be used in compilation: $(which python). Is this alright (y/N)? "
read -r answer
answer=${answer:-N}
case $answer in
[nN]* ) echo "Aborting."; exit 1;;
*) ;;
esac

finish() {
  rv=$?
  cd - >/dev/null
  exit $rv
}

trap finish EXIT INT TERM

cd ~/local/src/vim

make distclean
./configure --prefix=$HOME/local \
	--enable-gui=no \
	--enable-multibyte \
	--enable-rubyinterp \
        --enable-python3interp \
	--enable-fail-if-missing
rvm use default # switch back to desired Ruby
