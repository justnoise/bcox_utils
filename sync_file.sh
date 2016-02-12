#!/bin/bash

# todo, allow user to specify scp options on the command line

do_sync() {
    scp_args=$1
    src_file=$2
    dest_location=$3
    echo "scp $scp_args $src_file $dest_location"
    scp $scp_args $src_file $dest_location
}

if [ $# -lt 2 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name [scp args] source_file destination"
    exit 1
fi

# grab everything until the last 2 arguments, those are the arguments
# we'll pass to scp
scp_args=""
while [ "$3" != "" ]; do
    scp_args+="$1 "
    shift
done

src=$1
dest=$2

if [ ! -f "$src" ]; then
    "Could not find $src, are you in the correct directory?"
    exit 2
fi

platform=`uname`
if [ "$platform" = "Darwin" ]; then
    stat_cmd='stat -f %m'
    date_cmd='date +%s'
elif [ "$platform" = "Linux" ]; then
    stat_cmd='stat --format %Y'
    date_cmd='date +%s'
else
    echo "Your plaform: $platform is not supported"
    exit 1
fi

last_sync=0
while true; do
    mtime=`$stat_cmd $src`
    if [ "$mtime" -gt "$last_sync" ]; then
	do_sync "$scp_args" "$src" "$dest"
	last_sync=`$date_cmd`
    fi
    sleep 2
done
