#!/bin/bash

grp="lab"
sep='0'

for un in {1..20}
do
  if [[ $un == '10' ]]; then
    sep=''
  fi
  un=$sep$un
  userd=$grp$un
  echo $userd
#  useradd -m $userd
  echo -e $userd$un"\n"$userd$un | passwd $userd

done

echo ""
echo "Press any key ..."
read
