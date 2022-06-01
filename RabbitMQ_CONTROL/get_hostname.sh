#!/bin/bash
#=========================================================================
#server=""               # server IP
#port=22                 # port
#connect_timeout=5       # Connection timeout
SERVER_HOSTS=()
#==========================================================================
while IFS=, read -r IP HOST
do
    SERVER_HOSTS+=($HOST)
done < ./PROD/server.csv
HOST_NAME=${SERVER_HOSTS[@]}
echo $HOST_NAME
