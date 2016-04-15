#!/bin/bash

if [ $# -lt 1 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name remote_destination"
    exit 1
fi
remote_destination=$1

platform=`uname`
use_inotify=1
if [ "$platform" != "Linux" ]; then
    use_inotify=0
fi

while true
do
    rsync -avP --delete --exclude='.git/' --exclude ".tox/" --exclude "_trial_temp.*/" ./ $remote_destination
    if [[ use_inotify == 0 ]]; then
	inotifywait -r -e create,delete,modify,move ./
    else
	sleep 3
    fi
done
