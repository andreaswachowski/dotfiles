#!/bin/bash

for month in 01_january 02_february 03_march 04_march 05_may 06_june 07_july 08_august 09_september 10_october 11_november 12_december
do
  mkdir $month
done
mkdir -p doc/magazines/{acm_computing_surveys,cacm,ieee_computer,ieee_software,mit_technology_review}
mkdir -p finanzen/{t-mobile,targobank,telekom,vattenfall,vtb,steuererklärung,flatex,diba,quicken2017,anlage}
mkdir -p fortbildung/{lectures,books,exercises}
mkdir notes
