#!/bin/bash
# Copyright 2014 Bruno Rahle
# Checks the requirements for django-quickstart.

function get_installed {
    local result=$1
    local what=$(which $2)
    if [ -z "$what" ]
    then
        echo "ERROR: Cannot detect $2! Make sure it is installed!"
        exit 1
    fi
    eval $result="'$what'"
}

# Installations:
# Check if Python 2 is installed
get_installed PYTHON python2
export PYTHON=$PYTHON
# Check if Git is installed
get_installed GIT git
export GIT=$GIT
# Check if pip is installed
get_installed PIP pip
export PIP=$PIP

# Configurations:
# Check if git has user name and e-mail correctly configured.
git_username=$($GIT config --global user.name)
if [ -z "$git_username" ]
then
    echo "ERROR: git username unconfigured!"
    echo "To configure, run 'git config --global user.name \"<Your Name>\"'"
    exit 1
fi
git_email=$($GIT config --global user.email)
if [ -z "$git_email" ]
then
    echo "ERROR: git e-mail unconfigured!"
    echo "To configure, run 'git config --global user.email \"you@example.com\"'"
    exit 1
fi

