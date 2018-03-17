#!/usr/bin/env bash

DIFF=486604799
TEXT="The Times 03/Jan/2009 Chancellor on brink of second bailout for banks";
STARTNONCE=0
UNIXTIME=0

if [ -n "$5" ]; then UNIXTIME="$5"; fi
if [ -n "$4" ]; then DIFF="$4"; fi
if [ -n "$3" ]; then STARTNONCE="$3"; fi
if [ -n "$2" ]; then TEXT="$2"; fi
if [ -n "$1" ]; then
	KEY=`cat ../keys/$1/btc_public.key`

	echo "Unix Epoch  :" $UNIXTIME
	echo "Start Nonce :" $STARTNONCE
	echo "Public Key  :" $KEY
	echo "Text        :" $TEXT
	echo "Difficulty  :" $DIFF
	echo ""
	./blockgen.bin $KEY "$TEXT" $DIFF $STARTNONCE $UNIXTIME;
	
	while [ 1 ]; do
		afplay /System/Library/Sounds/Basso.aiff 
	done
else
	echo "usage: ./mineGensis.sh <KeyName> <Text optional> <StartNonce optional> <Difficulty optional> <UnixTime optional>"
fi