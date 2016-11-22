#!/bin/bash

for folder in $(find . -type d -links 2 | sed 's/\.\/\(.*\)/\1/');do
  echo loading /$folder/
  cat $folder/dump | dconf load /$folder/
done
