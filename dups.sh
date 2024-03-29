#!/bin/bash

files=$(grep -m 1 name= Makefile | cut -d= -f 2).tex

doit()
{
  flag=$1
  cat $files \
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

g="grep -iE 'functionality|actually|basically|utilize|methodology|essentially' $files"

if $g -q; then
  echo Obnoxious words:
  $g
  exit 1
fi

exit 0
