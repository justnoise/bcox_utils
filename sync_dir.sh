#!/bin/bash

if [ $# -lt 1 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name remote_destination"
    exit 1
fi
remote_destination=$1

platform=`uname`
if [ "$platform" != "Linux" ]; then
    echo "Your plaform: $platform is not supported"
    exit 1
fi

while /bin/true
do
    rsync -avP --delete --exclude='.*/.git/.*' --exclude "./.tox/.*" --exclude "./_trial_temp.*/" ./ $remote_destination
    inotifywait -r -e create,delete,modify,move ./
done
