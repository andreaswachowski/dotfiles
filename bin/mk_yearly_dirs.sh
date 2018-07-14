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
for month in 01_january 02_february 03_march 04_march 05_may 06_june 07_july 08_august 09_september 10_october 11_november 12_december
do
  mkdir $month
done
mkdir -p doc/magazines/{acm_computing_surveys,cacm,ieee_computer,ieee_software,mit_technology_review}
mkdir -p finanzen/{t-mobile,targobank,telekom,vattenfall,vtb,steuererklärung,flatex,diba,quicken2017,anlage}
mkdir -p fortbildung/{lectures,books,exercises,anki}

NOTES=~/Documents/Dropbox/notes/$YEAR
mkdir "$NOTES"
cd "$NOTES"
mkdir -p reading/articles
mkdir -p reading/books
mkdir todos

cd "$CURRENT_DIR"
echo "Don't forget to archive old directories"
