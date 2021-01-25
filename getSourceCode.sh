#!/bin/bash

# import utils
source ./utils.sh

USER="Axel-KIRK"
PASSWORD="Pingui94!"
REPO="https://${USER}:${PASSWORD}@github.com/GraphikChannel/vimeoDeploy.git"

getRepo(){ # arg 1 is the location where put the repository
    # check if git bin exist
    if isCommandExist git; then 
        echo '--> Clone repo'
        git clone $REPO $1
    else
        echo '--> Install git'
        installAPTPackage git
        getRepo
    fi
}

getRepo /var/www/vimeoApp