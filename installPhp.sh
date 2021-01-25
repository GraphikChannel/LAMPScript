#!/bin/bash

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