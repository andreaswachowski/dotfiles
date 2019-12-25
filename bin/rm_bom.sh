#!/bin/sh

sed '1s/^\xEF\xBB\xBF//' < "$1"
