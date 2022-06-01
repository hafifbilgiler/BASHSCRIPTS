#!/bin/bash
#==========================VARIABLES==================================
RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'
Exit_Code=0
Response_Code=0
Succes_Server=${@: -1} #Get last argument
Hosts=${@:1:$#-1} #get arguments without lastone
Log_File='cluster_status.txt'
#=====================================================================
for SRV in $Hosts
do
    Node_Url_Check=$(curl -i -s -u cluster_control:pass 'https://'$Succes_Server':15671/api/nodes?columns=name,running' --insecure)
    Node_Status=$(echo $Node_Url_Check | grep -oP '(?<="rabbit@'$SRV'","running")[^"]*' | grep -o "[[:alpha:]]*")
    Alarm_Url_Check=$(curl -i -s -u cluster_control:pass 'https://'$Succes_Server':15671/api/health/checks/alarms' --insecure)
    Alarm_Status=$(echo $Alarm_Url_Check | grep -oP '(?<="rabbit@'$SRV'","resource":")[^"]*')
    if [ $Node_Status == 'false' ]
    then
      #echo -e "$RED Node Is Not Running: ---> $SRV $NOCOLOR"
      STATUS="NOT RUNNING"
      Exit_Code=1
    else
      # Add Count to write once below message
     #echo -e "$GREEN We Do Not Have Problem About Cluster $NOCOLOR"
      #echo -e "$GREEN Node Is Running: ---> $SRV $NOCOLOR"
      STATUS="RUNNING"
      Exit_Code=0
    fi
    line_1="NODE:$SRV"
    line_2="STATUS:$STATUS"
    if [[ $Alarm_Status == *"d"* ]] || [[ $Alarm_Status == *"m"* ]]
    then
     #echo -e "$RED Yo Have Problem On This Server:---> $SRV $NOCOLOR"
     #echo -e "$RED $Alarm_Status $NOCOLOR"
     ALARM=$Alarm_Status
     Exit_Code=1
    elif [[ $Node_Status != 'false' ]]
    then
     #echo -e "$GREEN You Do Not Have Alarms $NOCOLOR"
     ALARM="You Do Not Have Alarms"
    #echo -e "$GREEN You Do Not Have Alarms $NOCOLOR"
    Exit_Code=0
    fi
    line_3="ALARMS:$ALARM"
    output="${line_1}\n${line_2}\n${line_3}"
    echo -e $output 
done
echo -e "EXIT_CODE:$Exit_Code"