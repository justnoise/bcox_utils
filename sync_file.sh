#!/bin/bash

# this only works on a mac, just need to change
# calls to stat and date to get it working on linux

sync_file() {
    src_file=$1
    dest_location=$2
    echo "$src_file $dest_location"
    scp $src_file $dest_location
}

src=$1
dest=$2

last_sync=0
while true; do
    mtime=`stat -f "%m" $src`
    if [ "$mtime" -gt "$last_sync" ]; then
	sync_file $src $dest
	last_sync=`date "+%s"`
    fi
    sleep 2
done
