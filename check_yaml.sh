RESULT=0
for filename in `find . -name '*.yml' -o -name '*.yaml'`; do
    if ! $(cat $filename | python -c 'import yaml,sys;yaml.safe_load(sys.stdin)'); then
	RESULT=1
	echo "invalid yaml in $filename"
    fi
done

if [ $RESULT == 0 ]; then
    echo 'All OK'
fi
exit $RESULT
