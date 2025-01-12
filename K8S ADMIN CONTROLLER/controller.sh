#!/bin/bash
#==========================COLOR_VARIABLES
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
#==================================
#echo -e "$PURPLE test output $NOCOLOR"
#==================================VARIBLES
#ping skylight-cluster
cluster_api_address=(
https://skylight-cluster:6443
)
cluster_token_list=(
"skylight-cluster:token"
)
insecure_="--insecure-skip-tls-verify"

while true
do
       echo -e "$GREEN  ============================================================ $NOCOLOR"
       echo -e "$GREEN |----------------- 0) LIST CLUSTER ADDRESS                   |$NOCOLOR"
       echo -e "$GREEN |----------------- 1) PRINT THE CLUSTER COUNTS               |$NOCOLOR"
       echo -e "$GREEN |----------------- 2) CONNECT THE CLUSTER                    |$NOCOLOR"
       echo -e "$GREEN |----------------- 3) EXIT FROM SCRIPT                       |$NOCOLOR"
       echo -e "$GREEN  ============================================================ $NOCOLOR"
       read -p "WHICH ONE DO YOU WANT ?: " COMMAND
       if [[ $COMMAND > 3 || $COMMAND < 0 ]]
       then
         echo -e "$RED WE DON'T HAVE YOUR COMMAND IN THE SECTION $NOCOLOR"
       fi
       echo -e "$GREEN YOUR INPUT:--->$COMMAND $NOCOLOR"
       case $COMMAND in
       0)
         COUNT=1
         echo -e "$CYAN YOUR CLUSTER LIST -------> : $NOCOLOR"
         for address in "${cluster_api_address[@]}"; do
          echo -e "  $COUNT-) $YELLOW $address $NOCOLOR"
          ((COUNT++))
         done
         ;;
       1)
        COUNT=0
        for address in "${cluster_api_address[@]}"; do
        ((COUNT++))
        done
        echo -e "$PURPLE YOUR CLUSTER COUNT  ------->: $COUNT  $NOCOLOR"
         ;;
       2)
         while true
         do
            echo -e "         $PURPLE CHOOSE CLUSTER TO CONNECT(TYPE CLUSTER NAME):$NOCOLOR"
            echo -e "         $PURPLE TYPE 0 TO TURN BACK :$NOCOLOR"
            COUNT=1
            for address in "${cluster_api_address[@]}"; do
              CLS_NAME=$(echo $address | awk -F[/:] '{print $4}')
              echo -e "             $COUNT-) $YELLOW $CLS_NAME $NOCOLOR"
              ((COUNT++))
             done
             read -p "WHICH ONE DO YOU WANT ?: " COMMAND_1
             if [[ $COMMAND_1 == *"0"* ]]; then
             break;
             fi
             for i in "${cluster_token_list[@]}"; do
                KEY="${i%%:*}"
                VALUE="${i##*:}"
                if [[ $COMMAND_1 == *"$KEY"* ]]; then
                   TOKEN_=$(echo $VALUE)
                   for address in "${cluster_api_address[@]}"; do
                   CLS_NAME=$(echo $address | awk -F[/:] '{print $4}')
                   if [[ $COMMAND_1 == *"$CLS_NAME"* ]]; then
                   CLS_API=$(echo $address)
                   fi
                   done
                   #echo $TOKEN_
                   #echo $CLS_API
                fi
             done
             while true
             do
                echo -e "$PURPLE |=========================================================|$NOCOLOR"
                echo -e "$PURPLE |   0) TURN BACK                                          |$NOCOLOR"
                echo -e "$PURPLE |   1) LIST THE ALL NAMESPACES                            |$NOCOLOR"
                echo -e "$PURPLE |   2) BE FREE                                            |$NOCOLOR"
                echo -e "$PURPLE |   3) LIST ALL PODS THAT STATUS NOT RUNNING              |$NOCOLOR"
                echo -e "$PURPLE |=========================================================|$NOCOLOR"
                read -p "WHICH ONE DO YOU WANT ?: " COMMAND_CLS
                case $COMMAND_CLS in
                0)
                  echo -e "$PURPLE SEE YOU AGAIN"
                  break;
                ;;
                1)
                 kubectl get ns --server=$CLS_API --token=$TOKEN_ $insecure_
                ;;
                2)
                  #bash
                ;;
                3)
                 kubectl get pods -A --server=$CLS_API --token=$TOKEN_ $insecure_ | grep -v Running
                ;;
                esac
             done
         done
         ;;
       3)
         echo -e "$PURPLE SEE YOU ADMIN, ENJOY YOURSELF $NOCOLOR"
         break;
         ;;
     esac
done