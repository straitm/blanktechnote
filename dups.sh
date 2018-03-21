#!/bin/bash

doit()
{
  flag=$1
  cat blanktechnote.tex \
  | tr ' ' '\n' \
  | tr -d ' .,:' \
  | uniq -c \
  | grep -v '. .$' \
  | grep -v '2 had$' \
  | grep -v '2 do$' \
  | grep -v '2 that$' \
  | grep $flag ' [2-9] [A-Za-z]'
}

if doit -q; then
  echo Duplicated words:
  doit
  exit 1
fi
exit 0
