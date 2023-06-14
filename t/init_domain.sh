#!/bin/bash

echo "### Enter the server IP ###"
read ip;
i=0

while [ $i -le 10 ]
do
    if grep -q "web$i.nfauconn.42.fr" /etc/hosts; then
        echo "web$i.nfauconn.42.fr exist !"
    else
        echo "web$i.nfauconn.42.fr create "
        echo "$ip web$i.nfauconn.42.fr" >> /etc/hosts
    fi
  ((i++))
done


if grep -q "adminer.nfauconn.42.fr" /etc/hosts; then
    echo "adminer.nfauconn.42.fr exist !"
else
    echo "adminer.nfauconn.42.fr create "
    echo "$ip adminer.nfauconn.42.fr" >> /etc/hosts
fi

if grep -q -E "^nfauconn.42.fr$" /etc/hosts; then
    echo "nfauconn.42.fr exist !"
else
    echo "nfauconn.42.fr create "
    echo "$ip nfauconn.42.fr" >> /etc/hosts
fi
