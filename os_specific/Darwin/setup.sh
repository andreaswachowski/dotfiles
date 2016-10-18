# vi: ts=2 sw=2 expandtab

DOTFILES=~/dotfiles # Assume dotfiles is checked out here
DIR=$(dirname $0)

for setup in $(ls $DIR/setups)
do
  echo Executing setup for $setup ...
done

