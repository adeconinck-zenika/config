#!/bin/bash

for folder in $(find . -type d -links 2 | sed 's/\.\/\(.*\)/\1/');do
  ignored=$folder/ignored
  if [ -f $ignored ];then
    dconf dump /$folder/ |
      grep -v -f $ignored |
      sed '/^\[.*\]$/ {N; s/\[.*\]\n$//}' |
      uniq >$folder/dump
  else
    dconf dump /$folder/ |
      sed '/^\[.*\]$/ {N; s/\[.*\]\n$//}' |
      uniq >$folder/dump
  fi
done
