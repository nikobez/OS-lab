#!/bin/bash

inDir=$1

if [ -z $1 ]; then
  inDir="./reports"
fi

IFS=$'\n'

for file in $(find $inDir -type f); do
  fext=${file: -3}
#  echo "$file type $fext"
  fstr="adduser"
  if [ $fext == '.md' ]; then
    echo -e "\033[32m $file \033[0m"
    for tstr in $(cat $file); 
    do
      idx=$( expr match "$tstr" '\($fstr\)' )
      if [[ $idx > 0 ]]; then 
        echo $tstr 
      fi
    done
  else
    echo -e "\033[31m $file \033[0m"
  fi
done

echo ""