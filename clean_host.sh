#!/bin/bash

if [ $# -lt 1 ]; then
    script_name=`basename $0`
    echo "Usage: $script_name line_number"
    exit 1
fi

line_number=$1
sed -i.bak -e "${line_number}d" $HOME/.ssh/known_hosts
