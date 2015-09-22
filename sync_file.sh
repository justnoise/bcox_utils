#!/bin/bash

# this only works on a mac, you'll need to change
# calls to stat and date to get it working on linux

do_sync() {
    src_file=$1
    dest_location=$2
    echo "$src_file $dest_location"
    scp $src_file $dest_location
}

if [ $# -lt 2 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name source_file destination"
    exit 1
fi

src=$1
dest=$2
if [ ! -f "$src" ]; then
    "Could not find $src, are you in the correct directory?"
    exit 2
fi

last_sync=0
while true; do
    mtime=`stat -f "%m" $src`
    if [ "$mtime" -gt "$last_sync" ]; then
	do_sync $src $dest
	last_sync=`date "+%s"`
    fi
    sleep 2
done
