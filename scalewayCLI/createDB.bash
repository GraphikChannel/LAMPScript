#!/bin/bash

# This script will create database instance, + add database + import .sql

# this will force exit when return code form a command is not 0 ~ mean not good
set -e

SECRET_KEY=3dc7b92c-d18c-4247-92d1-ffd4875d3563
PROJECT_ID=715014a1-cb21-4d37-8fa8-e93bfa0fdd29
REGION=fr-par
DBPASS="[(W>J5aGLx"
DBNAME="vimeodb"
SQLPATH="../database/vimeodb.sql"
DBTYPE="db-dev-s"

# VAR=$(..) will store the output of this command line
JSON=$(curl -X POST -H "Content-Type: application/json" \
    -H "X-Auth-Token: $SECRET_KEY" https://api.scaleway.com/rdb/v1/regions/$REGION/instances \
    -d "{
    \"project_id\": \"$PROJECT_ID\",
    \"name\": \"$DBNAME\",
    \"engine\": \"MySQL-8\",
    \"tags\": [\"$DBNAME\"],
    \"is_ha_cluster\": true,
    \"node_type\": \"$DBTYPE\",
    \"disable_backup\": true,
    \"user_name\": \"$DBNAME\",
    \"password\": \"$DBPASS\"
}")

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### JSON RESULT IS :  \n"
echo $JSON

# we extract the id from the JSON
DBID=$(jq -r '.id' <<<"$JSON")

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### DATABASE ID IS :  \n"
echo "$DBID"

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### WAITING FOR DB CREATION (could take 5-10min):  \n"
SUMUP=$(./scw.exe rdb instance wait $DBID)

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### DATABASE READY :  \n"

echo "$SUMUP"

ID=$(echo "$SUMUP" | grep -E "^ID" | awk -F ' ' '{print $2}')
echo -e "\n\n #### ID :  \n"
echo "$ID"

IP=$(echo "$SUMUP" | grep -E "^IP" | awk -F ' ' '{print $2}')
echo -e "\n\n #### IP :  \n"
echo "$IP"

PORT=$(echo "$SUMUP" | grep -E "^Port" | awk -F ' ' '{print $2}')
echo -e "\n\n #### PORT :  \n"
echo "$PORT"

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### CREATE DATABASE INSIDE OF OUR INSTANCE :  \n"
./scw.exe rdb database create instance-id=$ID name=$DBNAME

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### IMPORT DATABASE :  \n"
mysql -h $IP --port $PORT -u $DBNAME -p$DBPASS $DBNAME <$SQLPATH

SETTINGSCHANGE=$(curl -X PUT -H "Content-Type: application/json" \
    -H "X-Auth-Token: $SECRET_KEY" https://api.scaleway.com/rdb/v1/regions/$REGION/instances/$ID/settings \
    -d "{
    "settings": [
        {
            \"name\": \"max_connections\",
            \"value\": \"3000\"
        }
    ]
}")
echo "$SETTINGSCHANGE"

echo -e "\n\n ###########################################  \n"
echo -e "\n\n #### END OF SCRIPT :  \n"
