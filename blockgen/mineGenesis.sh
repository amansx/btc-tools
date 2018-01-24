#!/usr/bin/env bash

DIFF=486604799

if [ -n "$2" ]; then
	TEXT="$2"
else
	TEXT="The Times 03/Jan/2009 Chancellor on brink of second bailout for banks";
fi

if [ -n "$1" ]; then
	KEY=`cat ../keys/$1/btc_public.key`

	echo "Public Key:" $KEY
	echo "Text      :" $TEXT
	echo "Difficulty:" $DIFF
	
	./blockgen.bin $KEY $TEXT $DIFF;
else
	echo "usage: ./mineGensis.sh keyname text"
fi