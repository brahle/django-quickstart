#!/bin/bash
# Copyright Bruno Rahle 2014

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
    # call with a prompt string or user a default
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


