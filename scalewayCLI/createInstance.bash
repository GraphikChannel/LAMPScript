#!/bin/bash

# This script will 

# this will force exit when return code form a command is not 0 ~ mean not good
set -e

RESULT=$(./scw.exe instance server create \
image="ubuntu_bionic" \
type="GP1-XS" \
name="vimeoApp" \
ip=new \
root-volume=l:150G \
zone=fr-par-1 \
project-id=715014a1-cb21-4d37-8fa8-e93bfa0fdd29)


echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### RESULT IS :  \n"
echo "$RESULT"


echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### INSTANCE ID IS :  \n"
INSTANCEID=$(echo "$RESULT" | awk '$1=="ID" {print $2}')
echo "$INSTANCEID"

echo -e "\n\n #### INSTANCE IP IS :  \n"
IP=$(echo "$RESULT" | awk '$1=="PublicIP.Address" {print $2}')
echo "$IP"

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### WAITING FOR INSTANCE CREATION (could take 5-10min):  \n"
SUMUP=$(./scw.exe instance server wait $INSTANCEID)


echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### INSTANCE READY :  \n"
echo "$SUMUP"


echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### CONNECT SSH :  \n"

sleep 40

ssh -o "StrictHostKeyChecking no"  -i ../credentials/privateKeySSH root@$IP 'bash -s' < ../bash/deployLAMP.bash



