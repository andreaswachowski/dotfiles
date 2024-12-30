#!/bin/bash

set -e

if [ $# -ne 1 ]; then
  echo Usage: "$(basename "$0")" "<year>"
  exit 1
fi

CURRENT_DIR=$(pwd)
YEAR=$1

mkdir "$HOME/Documents/ownCloud/$YEAR"
cd "$HOME/Documents/ownCloud/$YEAR"
for month in 01_january 02_february 03_march 04_april 05_may 06_june 07_july 08_august 09_september 10_october 11_november 12_december; do
  mkdir $month
done
mkdir -p doc/magazines/{acm_computing_surveys,cacm,the_atlantic}
mkdir -p finanzen/{heizung,dkb,strom,steuererklärung,flatex,barclays,finanzmanager,anlage,rechnungen}
mkdir -p finanzen/rechnungen/telekom/{festnetz,mobilfunk}
mkdir -p fortbildung/{lectures,books,exercises,anki,youtube}
mkdir -p briefe_und_karten

# NOTES=~/Documents/ownCloud/notes/$YEAR
# mkdir "$NOTES"
# cd "$NOTES"
# mkdir -p reading/articles
# mkdir -p reading/books
# mkdir todos

cd "$CURRENT_DIR"
echo "Don't forget to archive old directories"
