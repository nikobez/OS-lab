#!/bin/bash

if [ -z $1 ]; then
  echo "Usage: check01.sh ip_address"
  exit
fi

userName="boss"
toDay=$(date +%d-%m-%y)
r_hostName=$(ssh $userName@$1 hostname)
ipAddr=$(ssh $userName@$1 ip -4 -br address show enp0s3)
r_group=${r_hostName:2:6}
r_user1=${r_hostName:9:2}
r_user2=${r_hostName:12:2}

echo -e "\033[33m"
echo -e "Today: " $toDay
echo -e "Check IP: " $1
echo -e "Host: " $r_hostName
echo -e "User: " $userName
echo -e "Interface eth: " $ipAddr
echo -e "\033[0m"

arg1=$(ssh $userName@$1 last | grep pts -c)
arg2=$(ssh $userName@$1 last | grep tty -c)
arg3=$(echo $r_hostName | awk '/[0-9][0-9][a-z][a-z][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{print $0}')
#arg3=$(echo "ws93is18-22-33" | awk '/ws[0-9][0-9][a-z][a-z][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{print $0}')
#echo $arg1 $arg2
#echo $arg3

let score=0

if [ ! -z $arg3 ]; then
   echo -e "\033[32mHostname check 	- success \033[0m"
   let score++
else
   echo -e "\033[31mHostname check 	- failed \033[0m"
   exit
fi

if [[ "$arg1" > "0" ]]; then
   echo -e "\033[32mSSH login 	- success \033[0m"
   let score++
else
   echo -e "\033[31mSSH login 	- failed \033[0m"
fi

if [[ "$arg2" > "0" ]]; then
   echo -e "\033[32mTTY login 	- success \033[0m"
   let score++
else
   echo -e "\033[31mTTY login 	- failed \033[0m"
fi

tput sgr0

if [[ $score == 3 ]]; then
   echo $toDay',lab01,'$r_group','$r_user1','$r_user2','$ipAddr','ok >> ./log/$r_group
else
   echo $toDay',lab01,'$r_group','$r_user1','$r_user2','$ipAddr','failed >> ./log/$r_group
fi
