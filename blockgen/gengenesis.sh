# https://github.com/lhartikk/GenesisH0
KEY=`cat ../keygen/keys/bitcoin_$1_public.key`
echo "Public Key:" $KEY
if [ -n "$1" ]; then
	./blockgen $KEY "The Times 03/Jan/2009 Chancellor on brink of second bailout for banks" 486604799;
else
	echo "usage: ./gengenesis.sh keyname"
fi