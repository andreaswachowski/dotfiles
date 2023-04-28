#! /usr/bin/env bash

set -e

eval "$(rbenv init -)"

for version in $(rbenv whence gem); do
  rbenv shell "$version"
  echo "Updating rubygems for $version"
  gem update --system --no-document --quiet
  echo ""
done
