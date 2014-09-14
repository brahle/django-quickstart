#!/bin/bash
# Copyright Bruno Rahle 2014

NGINX_FOLDER="/etc/nginx"
SITES_AVAILABLE="$NGINX_FOLDER/sites-available"
SITES_ENABLED="$NGINX_FOLDER/sites-enabled"
NGINX_CONF_TEMPLATE="$TEMPLATE_DIR/nginx.template"
NGINX_CONF="$SITES_AVAILABLE/$PROJ_NAME"

SERVER_NAME="$PROJ_NAME.com"
read -e -p "Domain name (no http:// or www.)? " -i "$SERVER_NAME" SERVER_NAME

sudo cp $NGINX_CONF_TEMPLATE $NGINX_CONF
sudo sed -ie "s/<SERVER_NAME>/$SERVER_NAME/g" $NGINX_CONF
sudo sed -ie "s|<STATIC_ROOT>|$VIRTUALENV_DIR|g" $NGINX_CONF
sudo sed -ie "s/<PORT>/$PROJ_LOCAL_PORT/g" $NGINX_CONF

if confirm "Do you want to add the site to sites-enabled [Y/n] ?"
then
    sudo ln -s -f $NGINX_CONF $SITES_ENABLED/$PROJ_NAME
    sudo service nginx restart
fi

