#!/bin/bash
#=============================================VARIABLES=============================================
RED="\033[1;31m"
GREEN="\033[1;32m"
CYAN="\033[1;36m"
PURPLE='\033[01;35m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
NOCOLOR="\033[0m"
EXIST="DENEME"
#============================================INFORMATION============================================
echo -e "${GREEN}THIS SCRIPT SPERATE THE PFX CERTIFIATE CREATED BY SYSTEM AND NETWORK SECURITY.${NOCOLOR}"
echo -e "${PURPLE}${UNDERLINE}This Script Created By HAFIFBILGILER.${NOCOLOR}\n\n"
#===================================================================================================
echo -e "${GREEN}Please enter the certificate path and name(Like This: /opt/certicate_name or /certificate*).${NOCOLOR}"
echo -e "${CYAN}Please enter just one certificate path.${NOCOLOR}"
read -p "Certificate Name:" name
echo -e "${GREEN} $name ${NOCOLOR}"
FILE=($(ls $name))
if [ -f "$FILE" ]
then
       echo -e "${GREEN} I Find This Certificate ${NOCOLOR}"
       echo -e "${PURPLE}${BOLD} Do Want Change PFX Certificate Name From Me(Y | N) ${NOCOLOR}"
       read -p "Your Choice:" choice
       if [[ "$choice" == "Y" ]]
       then
         read -p "Your Selected Name Without Extensions (/path/name):" choice
         mv $name $choice".pfx"
         FILE=$choice".pfx"
       fi
       read -p "What is your certificate name? (/path/name):" choice
while [ "$EXIST" != "MAC verified OK" ]
do
echo -e "${CYAN}${BOLD} Enter Password For .RSA File ${NOCOLOR}"
EXIST=$(openssl pkcs12 -in  $FILE -nocerts -nodes -out $choice".rsa" 2>&1)
if [[ "$EXIST" != "MAC verified OK" ]];then
echo "Mac verify error: invalid password?"
fi
done
EXIST="DENEME"
echo "MAC verified OK"
while [ "$EXIST" != "MAC verified OK" ]
do
echo -e "${CYAN}${BOLD} Enter Password To .CRT File${NOCOLOR}"
EXIST=$(openssl pkcs12 -in  $FILE -clcerts -nokeys -out $choice".crt" 2>&1)
if [[ "$EXIST" != "MAC verified OK" ]];then
echo "Mac verify error: invalid password?"
fi
done
echo "MAC verified OK"
#Please write condition with while
echo -e "${CYAN}${BOLD} You Are Sperated certificate With Success${NOCOLOR}"
fi
#add choice section