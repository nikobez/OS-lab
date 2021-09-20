#!/bin/bash

if [ -e ~/.ssh/known_hosts ]; then
    echo ""
    echo "Clear known hosts ..."
    rm ~/.ssh/known_hosts
fi

addresses=$(who)

for addr in $(who | awk -F' ' '/lab/ {print $1 $5}'); do
    addr=${addr/'('}
    addr=${addr/')'}

    labN=${addr:3:2}
    ipN=${addr:5}

    echo "Cheking lab "$labN " on ip address " $ipN
    echo ""

    ./check$labN.sh $ipN 

done

echo ""
echo "All requests checked."
echo -n "Press any key ..."
read
