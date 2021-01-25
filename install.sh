#!/bin/bash


# Active mod rewrite
sudo a2enmod php${PHP_VERSION}
sudo a2enmod rewrite
sudo phpenmod -v ${PHP_VERSION} mcrypt
sudo phpenmod -v ${PHP_VERSION} mbstring

# Active mod ssl
sudo a2enmod ssl 

#! Pensez à la timezone

sudo cp /etc/apache2/sites-avaiblable/000-default.conf /etc/apache2/sites-avaiblable/vimeoApp.conf

echo -e "\n\nRestarting Apache\n"
sudo service apache2 restart



