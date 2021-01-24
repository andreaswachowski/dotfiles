# vi: ts=2 sw=2 expandtab

DIR=$(dirname "$0")

brew bundle --file=$DIR/dots/Brewfile

[ -d "$DIR/setups" ] && for setup in $DIR/setups/*
do
  echo Executing setup for "$setup" ...
done
