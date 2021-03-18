#!/bin/bash

health=$(curl https://localhost:2379/health \
    --silent --insecure --location \
    --cert $(sudo docker inspect etcd |awk -F\= '/--cert-file/ {print $2; exit}' |sed 's/[",]//g') \
    --key $(sudo docker inspect etcd |awk -F\= '/--key-file/ {print $2; exit}' |sed 's/[",]//g'))
health_val=$(echo ${health} |awk -F\" '/health/ {print $4}')
echo ${health_val}
if [ X"${health_val}" == X"true" ];then
    exit 0
else
    exit 1
fi
