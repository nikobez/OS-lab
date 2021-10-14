#!/bin/bash

if [ -z $1 ]; then
  echo "Usage: check05.sh ip_address"
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

let user1_a=$r_user1+100
let user2_a=$r_user2+100
ch_ip1="192.168."$user1_a
ch_ip2="192.168."$user2_a

echo -e "IP1: "$ch_ip1
echo -e "IP2: "$ch_ip2
echo -e "\033[0m"

arg1=$(echo $r_hostName | awk '/[0-9][0-9][a-z][a-z][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{print $0}')
arg2_1=$(sshpass -p $pswd ssh $userName@$1 ip -4 -br a | grep "$ch_ip1" -c)
arg2_2=$(sshpass -p $pswd ssh $userName@$1 ip -4 -br a | grep "$ch_ip1" -c)
#arg3_1=$(sshpass -p $pswd ssh $userName@$1 ip route | grep -E ".*default.*"$ch_ip1 -c)

let score=0

if [ ! -z $arg1 ]; then
   echo -e "\033[32mHostname check 	- success \033[0m"
   let score++
else
   echo -e "\033[31mHostname check 	- failed \033[0m"
fi

if [[ $arg2_1 > 0 || $arg2_2 > 0 ]]; then
   echo -e "\033[32mDHCP client 	- success \033[0m"
   let score++
else
   echo -e "\033[31mDHCP client 	- failed \033[0m"
fi

tput sgr0

if [[ $score == 2 ]]; then
   echo $toDay',lab05,'$r_group','$r_user1','$r_user2','$ipAddr','ok >> ./log/$r_group
else
   echo $toDay',lab05,'$r_group','$r_user1','$r_user2','$ipAddr','failed >> ./log/$r_group
fi
