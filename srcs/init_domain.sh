#!/bin/bash

echo "### Enter the server IP ###"
read ip;

if grep -q -E "^nfauconn.42.fr$" /etc/hosts; then
    echo "nfauconn.42.fr already bound"
else
    echo "nfauconn.42.fr bound to $ip"
    echo "$ip nfauconn.42.fr" >> /etc/hosts
fi
