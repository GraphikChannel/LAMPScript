#!/bin/bash


# check if service is install
isServiceRunning(){ # arg 1 is the name of the service
    # -z test if the expansion of "$1" is a null string or not
    if [ -z "$1" ]
    then
        echo " /!\ No argument supplied isServiceRunning"
        exit 1
    fi

    /usr/sbin/service $1 status > /dev/null 2>&1
    # all linux command return a code, if it's 0 it mean it's OK 
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]
    then
        echo "--> $1 running"
        return 0
    else 
        echo "--> $1 not running"
        return 1
    fi
}

# start service
startService(){ # arg 1 is the name of the service
    # -z test if the expansion of "$1" is a null string or not
    if [ -z "$1" ]
    then
        echo " /!\ No argument supplied startService"
        exit 1
    fi

    /usr/sbin/service $1 start > /dev/null 2>&1
    # all linux command return a code, if it's 0 it mean it's OK 
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]
    then
        echo "--> $1 running"
        return 0
    else 
        echo "--> $1 not running, bug during start"
        return 1
    fi
}

# check if programme exist
isCommandExist(){ # arg 1 is the command name
    if [ -z "$1" ]
    then
        echo " /!\ No argument supplied in isCommandExist"
        exit 1
    fi

    which $1 > /dev/null 2>&1
    # all linux command return a code, if it's 0 it mean it's OK 
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]
    then
        echo "--> $1 here"
        return 0
    else 
        echo "--> $1 not here"
        return 1
    fi
}

installAPTPackage(){ # arg 1 is the package name
    if [ -z "$1" ]
    then
        echo " /!\ No argument supplied installAPTPackage"
        exit 1
    fi

    if isCommandExist sudo;
    then
        echo "--> Install with sudo"
        sudo apt-get update 
        sudo apt-get install $1
    else
        echo "--> Install without sudo"
        apt-get update 
        apt-get install $1 
    fi
        echo "--> $1 installed"

    return 0
}

echo "hey"