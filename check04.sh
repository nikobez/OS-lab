#!/bin/bash

if [ -z $1 ]; then
  echo "Usage: check03.sh ip_address"
  exit
fi

userName="teacher"
pswd="teacher"

toDay=$(date +%d-%m-%y)
r_hostName=$(sshpass -p $pswd ssh -o StrictHostKeyChecking=no $userName@$1 hostname)
ipAddr=$(sshpass -p $pswd ssh $userName@$1 ip -4 -br address show enp0s3)
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

arg1=$(echo $r_hostName | awk '/[0-9][0-9][a-z][a-z][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{print $0}')
arg2=$(sshpass -p $pswd ssh $userName@$1 grep "sda" -c /tmp/lsblk.txt 2>/dev/null)
arg3=$(sshpass -p $pswd ssh $userName@$1 grep "/dev/sdb1" -c /tmp/mount.txt 2>/dev/null)
arg4=$(sshpass -p $pswd ssh $userName@$1 grep "/dev/sda1" -c /tmp/df.txt 2>/dev/null)

let score=0

if [ ! -z $arg1 ]; then
   echo -e "\033[32mHostname check 	- success \033[0m"
   let score++
else
   echo -e "\033[31mHostname check 	- failed \033[0m"
fi

if [[ $arg2 > 0 ]]; then
   echo -e "\033[32mCheck lsblk 	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck lsblk 	- failed \033[0m"
fi

if [[ $arg3 > 0 ]]; then
   echo -e "\033[32mCheck mount 	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck mount 	- failed \033[0m"
fi

if [[ $arg4 > 0 ]]; then
   echo -e "\033[32mCheck df	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck df	- failed \033[0m"
fi

tput sgr0

if [[ $score == 4 ]]; then
   echo $toDay',lab04,'$r_group','$r_user1','$r_user2','$ipAddr','ok >> ./log/$r_group
else
   echo $toDay',lab04,'$r_group','$r_user1','$r_user2','$ipAddr','failed >> ./log/$r_group
fi
