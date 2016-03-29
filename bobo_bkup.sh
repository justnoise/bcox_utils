#!/bin/bash

if [ $# -lt 1 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name backup_destination"
    exit 1
fi

dest=$1
backup_config=~/.bobo_backup
if [ ! -f $backup_config ]; then
    echo "you need to create ~/$backup_config containing a list of files to backup"
    exit 2
fi

# for each line in ~/.bobo_backup, rsync it to the destination
for filename in `cat $backup_config`; do
    if [ -z $filename ]; then
	continue
    fi
    # todo: test to make sure its a file or directory
    rsync -avP --no-l --delete $filename $dest
done
