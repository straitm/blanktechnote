#!/bin/bash

name="$1"

echo Checking for duplicated words
./dups.sh
echo pdflatex for note pass 1
if ! pdflatex -interaction=errorstopmode -halt-on-error "$name.tex" &> tmp; then
  cat tmp
  exit 1
fi
echo bibtex for note pass 2
if ! bibtex "$name" &> tmp; then cat tmp; false; fi
echo pdflatex for note pass 2
if ! pdflatex -interaction=errorstopmode -halt-on-error "$name.tex" &> tmp; then
  cat tmp
  exit 1
fi
echo pdflatex for note pass 3
if ! pdflatex -interaction=errorstopmode -halt-on-error "$name.tex" &> tmp; then
  cat tmp
  exit 1
else
  grep -iEA1 'warning|undefined|hbox|rerun ' tmp
  exit 0
fi
