#!/bin/bash
# Copyright Bruno Rahle 2014
# MIT License

# This script helps recreate the virtual environment used in a project that
# django-quickstart created.
#
# It should be located in the root of the repository.


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
export ROOT_DIR="$(dirname $SCRIPT_DIR)"

function execute {
    echo "Executing $@..."
    $@
    if [ $? -eq 0 ]
    then
        echo "Done!"
        echo
    else
        echo "Failed!!!"
        exit 1
    fi
}

function confirm {
    read -r -p "${1:-Are you sure? [Y/n]} " response
    case $response in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        [nN][oO]|[nN])
            false
            ;;
        *)
            true
            ;;
    esac
}

REQ=$SCRIPT_DIR/requirements.txt

if ! confirm "This will save the currently installed pip package data to $REQ. Continue [Y/n] ? "
then
    exit 0
fi

# Save requirements
pip freeze > $REQ

echo "Requirements saved!"

