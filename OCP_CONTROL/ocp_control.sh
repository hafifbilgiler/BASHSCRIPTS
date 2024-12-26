#!/bin/bash
#==========================VARIABLES==================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
NOCOLOR='\033[0m'
URED='\033[4;31m'
UWHITE='\033[4;37m'
#=====================================================================
LIST_PODS=""
POD_MASTER=""
POD_IP_ADDRESS=""
INITIATE_CLUSTER=""
CONNECT_POD=""
POD_ALL=""
#= ===========CLUSTERS_API_ADDRESS====================================
cluster_api_address=(
https://api.ocp1:6443
https://api.ocp2:6443
https://api.ocp3:6443
)
#=====================================================================
echo -e "$PURPLE  ___  ___           ________ $NOCOLOR"
echo -e "$PURPLE |\  \|\  \         |\   __  \ $NOCOLOR"
echo -e "$PURPLE \ \  \_\  \        \ \  \_\ /_  $NOCOLOR"
echo -e "$PURPLE  \ \   __  \        \ \   __  \ $NOCOLOR"
echo -e "$PURPLE   \ \  \ \  \  ___   \ \  \_\  \  ___ $NOCOLOR"
echo -e "$PURPLE    \ \__\ \__\|\__\   \ \_______\|\__\ $NOCOLOR"
echo -e "$PURPLE     \|__|\|__|\|__|    \|_______|\|__| $NOCOLOR"
echo -e "$PURPLE THIS SCRIPT CREATED BY 8-SKYLIGHT $NOCOLOR"
echo -e "$PURPLE ________________________________v1.1 $NOCOLOR"
#====================================================================
#########################FIRST Area
unset TOKEN
unset URL
declare -A TOKEN
declare -A URL
###################################
read  -p "GIVE ME YOUR USERNAME: " USER
printf "\n"
while true
  do
   read -s -p "GIVE ME YOUR PASSWORD: " PASS
   printf "\n"
   read -s -p "GIVE ME YOUR PASSWORD AGAIN: " PASS1
   printf "\n"
  if [[ "$PASS" == "$PASS1" ]]; then
    for address in  "${cluster_api_address[@]}"; do
      LOGIN=$(oc login --insecure-skip-tls-verify --request-timeout=3 --server=$address -u $USER --password=$PASS 2>&1)
      #echo $LOGIN
     if [[ $LOGIN == *"Login successful"* ]]
     then
      echo -e "   $GREEN LOGIN SUCCESFUL $NOCOLOR"
           if [[ $address == *"gbpaas-t"* ]]; then
              CLS_NAME=$(echo $address | awk -F[/.] '{print $3}')
              #ALS=$(alias $CLS_NAME="oc login https://$CLS_NAME.fw.domain:port")
              echo -e "              $YELLOW $CLS_NAME $NOCOLOR"
            else
              CLS_NAME=$(echo $address | awk -F[/.] '{print $4}')
              #ALS=$(alias $CLS_NAME="oc login https://api.$CLS_NAME.fw.domain:port")
              echo -e "              $YELLOW $CLS_NAME $NOCOLOR"
            fi
         # Register The Key and Value For Array
             TKN=$(oc whoami --show-token)
             TOKEN[$CLS_NAME]=$TKN
             URL[$CLS_NAME]=$address
     else
      echo -e "   $RED LOGIN FAILED $NOCOLOR"
     fi
    done
    break
  else
    echo "YOUR PASSWORD DOES NOT MACTH"
   continue
  fi
  done
while true
do
        echo -e "$GREEN  ============================================================ $NOCOLOR"
        echo -e "$GREEN |----------------- 0) LIST CLUSTER ADDRESS                   |$NOCOLOR"
        echo -e "$GREEN |----------------- 1) LIST CLUSTERS NAMES                    |$NOCOLOR"
        echo -e "$GREEN |----------------- 2) PRINT CLUSTER COUNTS CLUSTERS NAMES    |$NOCOLOR"
        echo -e "$GREEN |----------------- 3) CONNECT THE CLUSTER                    |$NOCOLOR"
        echo -e "$GREEN |----------------- 4) EXIT FROM SCRIPT                       |$NOCOLOR"
        echo -e "$GREEN  ============================================================ $NOCOLOR"
#====================================================================
        read -p "WHICH ONE DO YOU WANT ?: " COMMAND
        EXIT_FROM_OCP="no"
        if [[ $COMMAND > 8  ||  $COMMAND -le -1  ]]
         then
            echo -e  "$RED UNFOURTUNALETY WE DO NOT HAVE YOUR COMMAND IN THE SECTION  $NOCOLOR"
         # break;
         fi
        case $COMMAND in
        0)
          COUNT=1
          echo -e "$CYAN YOUR CLUSTER LIST -------> : $NOCOLOR"
          for address in  "${cluster_api_address[@]}"; do
            echo -e "      $COUNT-) $YELLOW $address $NOCOLOR"
          ((COUNT++))
          done
         ;;
        1)
         COUNT=1
         for CLUSTER_NAME in  "${cluster_api_address[@]}"; do
            if [[ $CLUSTER_NAME == *"gbpaas-t"* ]]; then
              CLS_NAME=$(echo $CLUSTER_NAME | awk -F[/.] '{print $3}')
              echo -e "     $COUNT-) $YELLOW $CLS_NAME $NOCOLOR"
            else
              CLS_NAME=$(echo $CLUSTER_NAME | awk -F[/.] '{print $4}')
              echo -e "     $COUNT-) $YELLOW $CLS_NAME $NOCOLOR"            
            fi
          ((COUNT++))
         done
         ;;
        2)
         COUNT=$(echo ${#cluster_api_address[@]})
         echo -e "         $YELLOW TOTAL COUNT=$COUNT $NOCOLOR"
         ;;
        3)
         while true
         do
         if [[ $EXIT_FROM_OCP == "yes" ]]; then
         echo "LOGOUT FROM OCP..."
         break;
         fi
         echo -e "         $PURPLE CHOOSE CLUSTER TO CONNECT(TYPE CLUSTER NAME):$NOCOLOR"
         echo -e "         $PURPLE TYPE 0 TO TURN BACK :$NOCOLOR"
         COUNT=1
         for address in  "${cluster_api_address[@]}"; do
            if [[ $address == *"****"* ]]; then
              CLS_NAME=$(echo $address | awk -F[/.] '{print $3}')
              echo -e "             $COUNT-) $YELLOW $CLS_NAME $NOCOLOR"
            else
              CLS_NAME=$(echo $address | awk -F[/.] '{print $4}')
              echo -e "             $COUNT-) $YELLOW $CLS_NAME $NOCOLOR"
            fi
          ((COUNT++))
         done
           COUNT=$(echo ${#cluster_api_address[@]})
           read -p "WHICH ONE DO YOU WANT ?: " COMMAND_CLS_1
           #if [[ $COMMAND_CLS -eq 0 ]]
           #then
           #  break
           #fi
           if [[ $COMMAND_CLS_1 -gt $COUNT  ||  $COMMAND_CLS_1 -le -1  ]] # Add Index Search
            then
             echo -e  "$RED UNFOURTUNALETY WE DO NOT HAVE YOUR COMMAND IN THE SECTION  $NOCOLOR"
             # break;
            fi
            SVR=$(echo "${URL[$COMMAND_CLS_1]}")
	    echo $SVR
            TKN=$(echo "${TOKEN[$COMMAND_CLS_1]}")
            LGN=$(oc login --server=$SVR --request-timeout=4 --token="$TKN" 2>&1)
	    echo $LGN
              if [[ $LOGIN == *"Login successful"* ]]
              then
                 echo -e "   $GREEN LOGIN SUCCESFUL $NOCOLOR"
              else
                 echo -e "   $RED LOGIN FAILED $NOCOLOR"
              fi
           while true
           do
           echo -e "$PURPLE |=========================================================|$NOCOLOR"
           echo -e "$PURPLE |   0) TURN BACK                                          |$NOCOLOR"
           echo -e "$PURPLE |   1) LIST THE ALL NAMESPACES                            |$NOCOLOR"
           echo -e "$PURPLE |   2) DELETE/RESTART ALL PODS IN CLUSTER                 |$NOCOLOR"
           echo -e "$PURPLE |   3) LIST ALL PODS THAT STATUS NOT RUNNING              |$NOCOLOR"
           echo -e "$PURPLE |   4) LIST ALL PODS IN THE NAMESPACES                    |$NOCOLOR"
           echo -e "$PURPLE |   5) DELETE ALL PODS IN THE NAMESPACE                   |$NOCOLOR"
           echo -e "$PURPLE |   6) RUN YOUR COMMAND                                   |$NOCOLOR"
           echo -e "$PURPLE |   7) GET TOP CPU USAGE FOR POD FROM ALL OCP             |$NOCOLOR"
           echo -e "$PURPLE |   8) GET TOP CPU USAGE FOR NODES                        |$NOCOLOR"
	   echo -e "$PURPLE |   9) GET ALL DC COUNT IN ALL NAMESPACES IN THE CLUSTER  |$NOCOLOR"
           echo -e "$PURPLE |=========================================================|$NOCOLOR"
           read -p "WHICH ONE DO YOU WANT ?: " COMMAND_CLS
           case $COMMAND_CLS in
             0)
              EXIT_FROM_OCP="yes"
              break
              ;;
             1)
               oc get ns
              ;;
             2)
              read -p "ARE YOU SURE(YES/NO): " COMMAND_NS
               if [[ $COMMAND_NS == "YES" ]]
               then
                 oc delete pods --all --all-namespaces
               else:
                 echo "I did not delete the pods."
               fi              
              ;;
             3)
              oc get pods --field-selector status.phase!=Running -A
              ;;
             4)
              echo -e "$RED"
              oc get ns 
              echo -e "$YELLOW"
              read -p "CHOOSE NAMESPACE: " COMMAND_NS
              echo -e "$CYAN"
              oc get pods -n $COMMAND_NS
              echo -e "$NOCOLOR"
              ;; 
             5)
              echo -e "$RED"
              oc get ns
              echo -e "$YELLOW"
              read -p "CHOOSE NAMESPACE: " COMMAND_NS
              echo -e "$CYAN"
              oc delete pods -n $COMMAND_NS
              echo -e "$NOCOLOR"
              ;;
             6)
              #bash
              ;;
             7)
              oc adm top pods --all-namespaces  --sort-by cpu --no-headers --use-protocol-buffers | head -10
              ;;
             8)
              oc adm top nodes  --sort-by cpu --no-headers --use-protocol-buffers | head -10
	      ;;
	     9)
              NS_LIST=$(oc get ns  --no-headers | awk '{print $1}' | grep -v "openshift")
              echo "CLUSTER NAME:   $COMMAND_CLS_1" >> list.txt
              for NS_NAME in $NS_LIST ; do
                 DC=$(oc get dc --no-headers -n $NS_NAME 2>&1)
       	         if [[ $DC == *"No resources found"* ]]; then
         	   echo "dc_count ----> 0 ----> $NS_NAME" >> list.txt
        	 else
	           COUNT_DC=$(echo "$DC" | wc -l)
                   echo "dc_count ----> $COUNT_DC ----> $NS_NAME" >> list.txt
                fi
	      done	
            esac
           done
         done
     ;; 
     4)
      echo -e "$PURPLE SEE YOU ADMIN, ENJOY YOURSELF $NOCOLOR" 
     break
     ;;
     esac
        
done

