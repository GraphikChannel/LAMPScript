#!/bin/bash

service apache2 start 
servie mysql start 
cd /var/www/vimeoApp
rm /var/www/vimeoApp/*
echo "git clone vimeo app here like `git clone https://github.com/GraphikChannel/vimeoDeploy.git .`"