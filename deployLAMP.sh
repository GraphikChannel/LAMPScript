#!/bin/bash

###################################################################################
#############################  UTILS FUNCTIONS
###################################################################################

# check if service is install
isServiceRunning() { # arg 1 is the name of the service
    # -z test if the expansion of "$1" is a null string or not
    if [ -z "$1" ]; then
        echo " /!\ No argument supplied isServiceRunning"
        exit 1
    fi

    /usr/sbin/service $1 status
    # all linux command return a code, if it's 0 it mean it's OK
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]; then
        echo "--> $1 running"
        return 0
    else
        echo "--> $1 not running"
        return 1
    fi
}

# start service
startService() { # arg 1 is the name of the service
    # -z test if the expansion of "$1" is a null string or not
    if [ -z "$1" ]; then
        echo " /!\ No argument supplied startService"
        exit 1
    fi

    /usr/sbin/service $1 start
    # all linux command return a code, if it's 0 it mean it's OK
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]; then
        echo "--> $1 running"
        return 0
    else
        echo "--> $1 not running, bug during start"
        return 1
    fi
}

# check if programme exist
isCommandExist() { # arg 1 is the command name
    if [ -z "$1" ]; then
        echo " /!\ No argument supplied in isCommandExist"
        exit 1
    fi

    which $1
    # all linux command return a code, if it's 0 it mean it's OK
    # This code is contain in $? after the command exe, we test if  === 0
    if [ $? -eq 0 ]; then
        echo "--> $1 here"
        return 0
    else
        echo "--> $1 not here"
        return 1
    fi
}

installAPTPackage() { # arg 1 is the package name
    if [ -z "$1" ]; then
        echo " /!\ No argument supplied installAPTPackage"
        exit 1
    fi

    if isCommandExist sudo; then
        echo "--> Install with sudo"
        sudo apt-get update
        sudo apt-get install -y $1
    else
        echo "--> Install without sudo"
        apt-get update
        apt-get install -y $1
    fi
    echo "--> $1 installed"

    return 0
}
###################################################################################
#############################  END UTILS FUNCTIONS
###################################################################################

###################################################################################
############################# START INSTALLATION
###################################################################################
echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## START INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"

echo -e "\n\n --> Configure Timezone\n"
# set noninteractive installation
export DEBIAN_FRONTEND=noninteractive
#install tzdata package
apt-get install -y tzdata
# set your timezone
ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

apt-get install -y git

###################################################################################
#############################  END START INSTALLATION
###################################################################################

###################################################################################
############################# APACHE INSTALLATION
###################################################################################

echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## APACHE INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"

APACHE_GROUP=www-data
VHOST_ROOT=/var/www
RUNLEVEL=1

# install Apache
echo -e "\n\n --> Installing Apache2 Web server\n"
apt-get -y install apache2
apt-get -y install apache2-doc
apt-get -y install apache2-utils
apt-get -y install libexpat1
apt-get -y install ssl-cert

echo "ServerName localhost" >>/etc/apache2/apache2.conf

apache2 -version

# configuration Apache
echo -e "\n\nSet Apache\n"

mkdir -p $VHOST_ROOT/vimeoApp
chmod g=rwx $VHOST_ROOT/vimeoApp
# change only group
chown :$APACHE_GROUP $VHOST_ROOT/vimeoApp

cat <<'EOF' >/var/www/vimeoApp/index.html
<html>
    <head>
        <title>Welcome to info.net!</title>
    </head>
    <body>
        <h1>Hello World</h1>
    </body>
</html>
EOF

cat <<'EOF' >/etc/apache2/sites-available/vimeoApp.conf
<VirtualHost *:80>  
        ServerAdmin webmaster@localhost  
        DocumentRoot /var/www/vimeoApp  
        ErrorLog ${APACHE_LOG_DIR}/error.log 
        CustomLog ${APACHE_LOG_DIR}/access.log combined  
</VirtualHost>
EOF

apache2ctl configtest
service apache2 start

a2ensite vimeoApp.conf
a2dissite 000-default.conf
service apache2 reload
service apache2 start

###################################################################################
#############################  END APACHE INSTALLATION
###################################################################################

###################################################################################
############################# PHP INSTALLATION
###################################################################################
echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## PHP INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"

PHP_VERSION="7.4"

echo -e "\n\nInstalling PHP & PHP Module\n"
apt-get -y install php${PHP_VERSION}
apt-get -y install libapache2-mod-php${PHP_VERSION}
apt-get -y install php${PHP_VERSION}-curl
apt-get -y install php${PHP_VERSION}-json
apt-get -y install php${PHP_VERSION}-dev
apt-get -y install php${PHP_VERSION}-gd
apt-get -y install php${PHP_VERSION}-intl
apt-get -y install php${PHP_VERSION}-xml
apt-get -y install php${PHP_VERSION}-zip
apt-get -y install php${PHP_VERSION}-pear
apt-get -y install php${PHP_VERSION}-mcrypt
apt-get -y install php${PHP_VERSION}-common
apt-get -y install php${PHP_VERSION}-mbstring
apt-get -y install php${PHP_VERSION}-mysql
apt-get -y install php${PHP_VERSION}-cli
apt-get -y install php${PHP_VERSION}-php-gettext
apt-get -y install php${PHP_VERSION}-fpm


a2enmod proxy_fcgi setenvif
a2enconf php7.4-fpm

###################################################################################
#############################  END PHP INSTALLATION
###################################################################################

###################################################################################
############################# MYSQL INSTALLATION
###################################################################################

echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## MYSQL INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"

DBNAME="vimeodb"
PASSWDDB="#8aV+shY"
NEWROOTPASS="[(W>J5aGLx"

createDB() {
    mysql -e "CREATE DATABASE ${DBNAME} /*\!40100 DEFAULT CHARACTER SET utf8 */;"
    mysql -e "CREATE USER ${DBNAME}@localhost IDENTIFIED BY '${PASSWDDB}';"
    mysql -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBNAME}'@'localhost';"
    mysql -e "FLUSH PRIVILEGES;"
}

initDB() {
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

echo -e "\n\n Change root password  \n"
mysql -u root -p'root' -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${NEWROOTPASS}';"

/usr/sbin/service mysql reload


###################################################################################
#############################  END MYSQL INSTALLATION
###################################################################################

###################################################################################
############################# PHPMYADMIN INSTALLATION
###################################################################################

echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## PHPMYADMIN INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"

PMAPASS="7V[[XSre"
service mysql start
service apache2 start

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-user string root" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $NEWROOTPASS" | debconf-set-selections # use this pass to connect to pma
echo "phpmyadmin phpmyadmin/mysql/app-pass password $PMAPASS" |debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $PMAPASS" | debconf-set-selections
echo 'Include /etc/phpmyadmin/apache.conf' >> /etc/apache2/apache2.conf  

apt-get -y install phpmyadmin

service apache2 reload
###################################################################################
#############################  END PHPMYADMIN INSTALLATION
###################################################################################

###################################################################################
############################# REPORT END INSTALLATION
###################################################################################

echo -e "\n\n ###########################################  \n"
echo -e "\n\n ################## REPORT END INSTALLATION  \n"
echo -e "\n\n ###########################################  \n"
echo -e "\n\n You have succefully install :  \n"
echo -e "\n\n --> apache :  \n"
apachectl -v

echo -e "\n\n --> mysql :  \n"
mysql -v

echo -e "\n\n --> php :  \n"
php -v

###################################################################################
#############################  END REPORT END INSTALLATION
###################################################################################
