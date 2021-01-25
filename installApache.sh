#!/bin/bash
source ./utils.sh

APACHE_GROUP=www-data
VHOST_ROOT=/var/www

echo -e "\n\n --> Configure Timezone\n"
# set noninteractive installation
export DEBIAN_FRONTEND=noninteractive
#install tzdata package
apt-get install -y tzdata
# set your timezone
ln -fs /usr/share/zoneinfo/Europe/Paris /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

# install Apache
echo -e "\n\n --> Installing Apache2 Web server\n"
RUNLEVEL=1
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

cat << 'EOF' > /var/www/vimeoApp/index.html
<html>
    <head>
        <title>Welcome to info.net!</title>
    </head>
    <body>
        <h1>Hello World</h1>
    </body>
</html>
EOF

cat << 'EOF' >/etc/apache2/sites-available/vimeoApp.conf
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

