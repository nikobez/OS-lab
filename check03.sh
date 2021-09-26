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
arg2=$(sshpass -p $pswd ssh $userName@$1 cat /tmp/dmesg.txt 2>/dev/null | grep "enp0s" -c)
arg3=$(sshpass -p $pswd ssh $userName@$1 cat /tmp/dmesg.txt 2>/dev/null | grep "fb0" -c)
arg4=$(sshpass -p $pswd ssh $userName@$1 cat /opt/myip.sh 2>/dev/null | grep "ip" -c)
arg5=$(sshpass -p $pswd ssh $userName@$1 cat /etc/sysemd/system/myip.service 2>/dev/null | grep "/opt/myip.sh")
arg6=$(sshpass -p $pswd ssh $userName@$1 systemctl status myip | grep "success" -c)

let score=0

if [ ! -z $arg1 ]; then
   echo -e "\033[32mHostname check 			- success \033[0m"
   let score++
else
   echo -e "\033[31mHostname check 			- failed \033[0m"
fi

if [[ $arg2 > 0 ]]; then
   echo -e "\033[32mCheck enp0s3			- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck enp0s3			- failed \033[0m"
fi

if [[ $arg3 > 0 ]]; then
   echo -e "\033[32mCheck fb0			- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck fb0			- failed \033[0m"
fi

if [[ $arg4 > 0 ]]; then
   echo -e "\033[32mCheck script myip.sh		- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck script myip.sh		- failed \033[0m"
fi

if [ ! -z $arg5 ]; then
   echo -e "\033[32mCheck myip.service		- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck myip.service		- failed \033[0m"
fi

if [[ $arg6 > 0 ]]; then
   echo -e "\033[32mCheck myip.service is started	- success \033[0m"
   let score++
else
   echo -e "\033[31mCheck myip.service is started	- failed \033[0m"
fi

tput sgr0

if [[ $score == 6 ]]; then
   echo $toDay',lab02,'$r_group','$r_user1','$r_user2','$ipAddr','ok >> ./log/$r_group
else
   echo $toDay',lab02,'$r_group','$r_user1','$r_user2','$ipAddr','failed >> ./log/$r_group
fi
