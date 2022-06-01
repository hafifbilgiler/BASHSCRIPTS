#!/bin/bash
#=========================================================================
server=""               # server IP
port=22                 # port
connect_timeout=5       # Connection timeout
SERVER_IP=()
#==========================================================================
while IFS=, read -r IP HOST
do
    SERVER_IP+=($IP)
done < ./PROD/server.csv
IP_ADDRESS=${SERVER_IP[@]}
for server in $IP_ADDRESS
do
timeout $connect_timeout bash -c "</dev/tcp/$server/$port"
if [ $? == 0 ];then
 echo $server
else
  server=""
fi
done
if [ server == "" ];then
echo "Every Server Is Not Reachable"
Exit_Code=1
else
Exit_Code=0
fi
exit $Exit_Code
