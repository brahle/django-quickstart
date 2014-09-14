#!/bin/bash
# Copyright Bruno Rahle 2014
# This script helps you start django project the right way.
# It was inspired by this blog post:
# http://www.jeffknupp.com/blog/2012/02/09/starting-a-django-project-the-right-way/

# Detect the directory of the source file. Taken from
# http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do 
    # resolve $SOURCE until the file is no longer a symlink
    DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
    SOURCE="$(readlink "$SOURCE")"
    [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
    # if $SOURCE was a relative symlink, we need to resolve it relative to the path
    # where the symlink file was located
done
export SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

# Set the default value of project name. If it is given as a parameter to the
# function, set it to that value, otherwise set it to 'project'.
if [ -z "$1" ]
then
    export PROJ_NAME="project"
else
    export PROJ_NAME="$1"
fi

export ROOT_DIR="$(pwd)"
export PROD_DIR=$ROOT_DIR
export VIRTUALENV_DIR="$ROOT_DIR/$PROJ_NAME-virtualenv"
export PROJ_DIR="$VIRTUALENV_DIR/$PROJ_NAME"
export LOG_DIR="$VIRTUALENV_DIR/log"
export DEV_DIR="/home/$USER/dev/"
export TEMPLATE_DIR="$SCRIPT_DIR/templates/"

export DJANGO_VERSION=1.6.5
export PROJ_LOCAL_PORT=8083

source $SCRIPT_DIR/functions.sh

function print_setup_data {
    echo
    echo "***************** SETUP INFORMATION *********************"
    echo "Project name: $PROJ_NAME"
    echo "Django version: $DJANGO_VERSION"
    echo "Local port used for production: $PROJ_LOCAL_PORT"
    echo "** Directories ******************************************"
    echo "Root dir: $ROOT_DIR"
    echo "Virtualenv dir: $VIRTUALENV_DIR"
    echo "Project dir: $PROJ_DIR"
    echo "Log dir: $LOG_DIR"
    echo "Development dir: $DEV_DIR"
    echo "*********************************************************"
    echo
}

function get_setup_data {
    print_setup_data
    while ! confirm
    do
        read -e -p "Project name? " -i "$PROJ_NAME" PROJ_NAME
        read -e -p "Django version? " -i "$DJANGO_VERSION" DJANGO_VERSION
        read -e -p "Local port (gunicorn to nginx)? " -i "$PROJ_LOCAL_PORT" \
            PROJ_LOCAL_PORT
        read -e -p "Root directory? " -i "$ROOT_DIR" ROOT_DIR
        export PROD_DIR=$ROOT_DIR
        export VIRTUALENV_DIR="$ROOT_DIR/$PROJ_NAME-virtualenv"
        read -e -p "Virtual environment directory? " -i "$VIRTUALENV_DIR" \
            VIRTUALENV_DIR
        export PROJ_DIR="$VIRTUALENV_DIR/$PROJ_NAME"
        export LOG_DIR="$VIRTUALENV_DIR/log"
        read -e -p "Log directory? " -i "$LOG_DIR" LOG_DIR
        read -e -p "Development directory? " -i "$DEV_DIR" DEV_DIR
        print_setup_data
    done
}

get_setup_data

execute mkdir -p $ROOT_DIR
cd $ROOT_DIR
execute mkdir -p $LOG_DIR

# Install Django for all users
execute sudo pip install Django==$DJANGO_VERSION

# Creating virtual environment
execute virtualenv $VIRTUALENV_DIR
cd $VIRTUALENV_DIR
source $VIRTUALENV_DIR/bin/activate

# Install the requirements inside virtual environment
execute pip install Django==$DJANGO_VERSION -r $TEMPLATE_DIR/env/requirements.txt

# Create Django project
execute django-admin.py startproject $PROJ_NAME

# Create the requirements file for the project
export ENV_DIR=$PROJ_DIR/.environment_settings/
execute mkdir $ENV_DIR
pip freeze > $ENV_DIR/requirements.txt

# Copy the environment scripts to the project
cp $TEMPLATE_DIR/env/*_environment.sh $PROJ_DIR

# Copy settings to the project
cp $TEMPLATE_DIR/settings/settings{,_global,_local}.py $PROJ_DIR/$PROJ_NAME/
sed -ie "s/<PROJECT_NAME>/$PROJ_NAME/g" $PROJ_DIR/$PROJ_NAME/settings*.py
sed -ie "s|<STATIC_ROOT>|$VIRTUALENV_DIR/static/|g" $PROJ_DIR/$PROJ_NAME/settings*.py
cd $PROJ_DIR
execute mkdir -p $PROJ_DIR/static
execute python manage.py syncdb

# Initialize south
cd $PROJ_DIR
execute python manage.py migrate

# Initialize fabric
cp $TEMPLATE_DIR/fabfile.py $PROJ_DIR/
sed -ie "s|<PRODUCTION_DIR>|$PROJ_DIR|g" $PROJ_DIR/fabfile.py
sed -ie "s|<DEV_DIR>|$DEV_DIR/$PROJ_NAME|g" $PROJ_DIR/fabfile.py

# Create git repository
# TODO(brahle): ask for user name and password if not set
cd $PROJ_DIR
execute git init
cp $TEMPLATE_DIR/sample.gitignore .gitignore
execute git add .
git commit -a -m "Initial commit for project $PROJ_NAME"

# Create development repository
execute mkdir -p $DEV_DIR
cd $DEV_DIR
execute git clone $PROJ_DIR
cp $PROJ_DIR/$PROJ_NAME/settings_local.py $DEV_DIR/$PROJ_NAME/$PROJ_NAME

# Collect static files for the first time
cd $PROJ_DIR
execute mkdir -p $VIRTUALENV_DIR/static
execute python manage.py collectstatic

# Set up gunicorn
cp $TEMPLATE_DIR/gunicorn_conf.py $VIRTUALENV_DIR
sed -ie "s|<PRODUCTION_DIR>|$PROJ_DIR|g" $VIRTUALENV_DIR/gunicorn_conf.py
sed -ie "s/<PORT>/$PROJ_LOCAL_PORT/g" $VIRTUALENV_DIR/gunicorn_conf.py
cd $VIRTUALENV_DIR

if confirm "Do you want to configure the webserver [Y/n] ?"
then
    # Initialize nginx
    cd $SCRIPT_DIR
    ./nginx_profile.sh

fi

if confirm "Do you want to start gunicorn [Y/n] ?"
then
    echo "You may kill this process anytime and restart gunicorn yourself."
    gunicorn -c $VIRTUALENV_DIR/gunicorn_conf.py $PROJ_NAME.wsgi:application
fi

