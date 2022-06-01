Servers=$@
for SRV in $Servers
do
Response_Code='curl -o /dev/null --silent --head --write-out '%{http_code}\n' -u cluster_control:MzT7mywPXQJA@a8# 'https://localhost:15671' --insecure'
Status=$(ssh root@"$SRV" $Response_Code)
if [[ $Status == "200n" ]]
then
Server_Name=$SRV
echo $Server_Name
break
fi
done
if [[ $Server_Name == "" ]]
then
echo -e "$RED Your Cluster Is Down $NOCOLOR"
Exit_Code=1
exit $Exit_Code
fi