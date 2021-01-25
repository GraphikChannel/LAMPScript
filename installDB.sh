#!/bin/bash
source ./utils.sh

## TODO: aller récuperer en auto les id dans le repo dans un fichier de config à faire

DBNAME="vimeodb"
PASSWDDB="#8aV+shY"

export DEBIAN_FRONTEND=noninteractive

createDB(){
    mysql -e "CREATE DATABASE ${DBNAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${DBNAME}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBNAME}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
}


initDB(){
    echo 'Init DB'
    if isCommandExist mysql; then
        if isServiceRunning mysql; then
            echo 'Create DB'
            createDB
            service mysql restart
        else
            echo 'Start service'
            startService mysql
            initDB
        fi
    else
        echo 'Install MySQL'
        apt-get update -y && apt-get -y install mysql-server
        initDB
    fi
}

initDB
