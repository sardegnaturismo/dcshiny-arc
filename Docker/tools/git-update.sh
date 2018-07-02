#!/bin/bash 
CONFIG_FILENAME="prod.config"

if [ ! -f ${CONFIG_FILENAME}  ]; then
    echo "Config file not found, exiting ..."
    exit;
else
    eval $(cat ${CONFIG_FILENAME})
fi

if [ ! -d DO_shiny ]; then
    git clone https://github.com/pjpalla/DO_shiny.git
else 
    cd DO_shiny
    # Get updates
    git fetch origin feature/invoice

    #check
    #UPSTREAM=${1:-'@{u}'}
    FORCED="n"
    UPSTREAM="@{u}"
    LOCAL=$(git rev-parse @)
    REMOTE=$(git rev-parse "$UPSTREAM")
    BASE=$(git merge-base @ "$UPSTREAM")
    echo "local hash: $LOCAL"
    echo "base  hash: $BASE"
    echo "remote hash: $REMOTE"

    if [ $LOCAL = $REMOTE ]; then
        echo "Local is up-to-date"
    fi
    if [ $LOCAL = $BASE ] || [ $FORCED = "y" ]; then
        echo "Need to pull or Forced"
        git reset --hard HEAD
        git clean -df
    elif [ $REMOTE = $BASE ]; then
        echo "Need to push"
    else
        echo "Diverged"
    fi
fi