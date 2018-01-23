# brew install coreutils
declare -a base58=(
	1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V W X Y Z 
	a b c d e f g h i j k m n o p q r s t u v w x y z
)

encodeBase58() {
    echo -n "$1" | sed -e's/^\(\(00\)*\).*/\1/' -e's/00/1/g' | tr -d '\n'
    dc -e "16i ${1^^} [3A ~r d0<x]dsxx +f" |
    while read -r n; do echo -n "${base58[n]}"; done
}

genkey(){
	# Bitcoin uses ECDSA so ECDSA keypairs are Bitcoin keypairs as well.
	# This generates the private key in the pem format that openssl uses.
	echo "Generating private key"
	openssl ecparam -genkey -name secp256k1 -rand /dev/random -out $PRIVATE_KEY

	# This generates the public key from the provided private key (which we just generated) and writes
	# it to a file in the pem format.
	echo "Generating public key"
	openssl ec -in $PRIVATE_KEY -pubout -out $PUBLIC_KEY

	echo "Generating public key compressed"
	openssl ec -in $PUBLIC_KEY -pubin -text -noout -conv_form compressed -out $PUBLIC_KEY_COMPRESSED

	# This takes the private key in the pem format, converts it to the DER format, 
	# and extracts from that format the 32 bytes for the private key and writes those as a hex string to a file.
	echo "Generating BitCoin private key"
	BTCPRK=`openssl ec -in $PRIVATE_KEY -outform DER|tail -c +8|head -c 32|xxd -p -c 32`
	echo -n $BTCPRK > $BITCOIN_PRIVATE_KEY

	# This takes the public key in the pem format, converts it to the DER format, 
	# and extracts from that format the 65 bytes for the public key and writes those as a hex string to a file.
	echo "Generating BitCoin public key"
	openssl ec -in $PRIVATE_KEY -pubout -outform DER|tail -c 65|xxd -p -c 65|tr -d '\n' > $BITCOIN_PUBLIC_KEY

	echo "Generating BitCoin Private key WIF"
	BTCPK=`cat $BITCOIN_PRIVATE_KEY`
	BTCP2="80"$BTCPK
	HASH1="$(echo $BTCP2 | xxd -r -p - | gsha256sum | head -c 64)"
	HASH2="$(echo $HASH1 | xxd -r -p - | gsha256sum | head -c 64)"
	MAGIC="$(echo $HASH2 | head -c 8)"
	PRIVATEWIF="$(encodeBase58 $BTCP2$MAGIC)"
	echo $PRIVATEWIF

	echo "Generating BitCoin Address"
	BTCPBK=`cat $BITCOIN_PUBLIC_KEY`
	AHASH1=$(echo -n $BTCPBK | xxd -r -p - | gsha256sum | head -c 64)
	AHASH2=$(echo -n $AHASH1 | xxd -r -p - | openssl dgst -rmd160 -binary | xxd -p)
	VERBYT=00$AHASH2
	AHASH3=$(echo -n $VERBYT | xxd -r -p - | gsha256sum | head -c 64)
	AHASH4=$(echo -n $AHASH3 | xxd -r -p - | gsha256sum | head -c 64)
	CHKSUM=$(echo -n $AHASH4 | head -c 8)
	BTCADDR="$(encodeBase58 $VERBYT$CHKSUM)"
	echo $BTCADDR
	
	echo "Files created!"
}

if [ -n "$1" ]; then
	FILE_NAME=$1
	KEYDIR="./keys"
	mkdir -p ${KEYDIR}
	PRIVATE_KEY=${KEYDIR}/${FILE_NAME}_private.pem
	PUBLIC_KEY=${KEYDIR}/${FILE_NAME}_public.pem
	PUBLIC_KEY_COMPRESSED=${KEYDIR}/${FILE_NAME}_public_compressed.pem
	BITCOIN_PRIVATE_KEY=${KEYDIR}/${FILE_NAME}_btc_uncompressed_private.key
	BITCOIN_PUBLIC_KEY=${KEYDIR}/${FILE_NAME}_btc_uncompressed_public.key
	genkey
else
	echo "usage: btckeygen.sh keyname"
fi