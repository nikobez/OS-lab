#!/bin/bash

if [ -z $1 ]; then
  echo "Usage: check02.sh ip_address"
  exit
fi

userName="teacher"
pswd="teacher"

toDay=$(date +%d-%m-%y)
r_hostName=$(sshpass -p $pswd ssh -o StrictHostkeyChecking=no $userName@$1 hostname)
ipAddr=$(sshpass -p $pswd ssh $userName@$1 ip -4 -br address show enp0s3)
r_group=${r_hostName:2:6}
r_user1=${r_hostName:9:2}
r_user2=${r_hostName:12:2}

echo -e "\033[33m"
echo -e "Today: " $toDay
echo -e "Check IP: " $1
echo -e "Host: " $r_hostName
echo -e "User: " $userName
echo -e "User1 for check: user"$r_user1
echo -e "User2 for check: user"$r_user2
echo -e "Group for check: " $r_group
echo -e "Interface eth: " $ipAddr
echo -e "\033[0m"

arg1=$(sshpass -p $pswd ssh $userName@$1 cat /etc/passwd | grep user$r_user1)
arg2=$(sshpass -p $pswd ssh $userName@$1 cat /etc/passwd | grep user$r_user2)
arg3=$(echo $r_hostName | awk '/[0-9][0-9][a-z][a-z][0-9][0-9]-[0-9][0-9]-[0-9][0-9]/{print $0}')
arg4=$(sshpass -p $pswd ssh $userName@$1 grep -w $r_group':x' /etc/group)
arg5=$(sshpass -p $pswd ssh $userName@$1 ls -l /tmp/file1.txt 2>/dev/null | awk '{print $1}' | grep "rwxr--r--")

echo $(sshpass -p $pswd ssh $userName@$1 ls -l /tmp/file1.txt 2>/dev/null | awk '{print $1}')

let score=0

if [ ! -z $arg3 ]; then
   echo -e "\033[32mHostname check 	- success \033[0m"
   let score++
else
   echo -e "\033[31mHostname check 	- failed \033[0m"
fi

if [ ! -z $arg1 ]; then
   echo -e "\033[32mCheck user1	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck user1	- failed \033[0m"
fi

if [ ! -z $arg2 ]; then
   echo -e "\033[32mCheck user2	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck user2	- failed \033[0m"
fi

if [ ! -z $arg4 ]; then
   echo -e "\033[32mCheck group	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck group	- failed \033[0m"
fi

if [ ! -z $arg5 ]; then
   echo -e "\033[32mCheck file	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck file	- failed \033[0m"
fi

tput sgr0

if [[ $score == 5 ]]; then
   echo $toDay',lab02,'$r_group','$r_user1','$r_user2','$ipAddr','ok >> ./log/$r_group
else
   echo $toDay',lab02,'$r_group','$r_user1','$r_user2','$ipAddr','failed >> ./log/$r_group
fi
