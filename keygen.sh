# brew install coreutils
# Taken from btcutils.sh
declare -a base58=(
	1 2 3 4 5 6 7 8 9 A B C D E F G H J K L M N P Q R S T U V W X Y Z 
	a b c d e f g h i j k m n o p q r s t u v w x y z
)

encodeBase58() {
    echo -n "$1" | sed -e's/^\(\(00\)*\).*/\1/' -e's/00/1/g' | tr -d '\n'
    dc -e "16i ${1^^} [3A ~r d0<x]dsxx +f" |
    while read -r n; do echo -n "${base58[n]}"; done
}
# END

genkey(){
	# Bitcoin uses ECDSA so ECDSA keypairs are Bitcoin keypairs as well.
	# This generates the private key in the pem format that openssl uses.
	PK=$(openssl ecparam -genkey -text -name secp256k1 -rand /dev/random 2>/dev/null)

	# This generates the public key from the provided private key (which we just generated) and writes
	# it to a file in the pem format.
	PBK=$(echo "${PK}" | openssl ec -in /dev/stdin -pubout 2>/dev/null)

	PBKC=$(echo "${PBK}" | openssl ec -in /dev/stdin -pubin -text -noout -conv_form compressed 2>/dev/null)

	# This takes the private key in the pem format, converts it to the DER format, 
	# and extracts from that format the 32 bytes for the private key and writes those as a hex string to a file.
	BTCPK=$(echo "${PK}" | openssl ec -in /dev/stdin -outform DER 2>/dev/null | tail -c +8 | head -c 32 | xxd -p -c 32 | tr -d '\n')

	# This takes the private key in the pem format, converts it to the DER public key format, 
	# and extracts from that format the 65 bytes for the public key and writes those as a hex string to a file.
	BTCPBK=$(echo "${PK}" | openssl ec -in /dev/stdin -pubout -outform DER 2>/dev/null | tail -c 65 | xxd -p -c 65 | tr -d '\n')

	BTCPBKC=$(echo "${PBK}" | openssl ec -in /dev/stdin -pubin -conv_form compressed -outform DER 2>/dev/null | xxd -p | tr -d '\n' | tail -c 66)

	# Override to test
	# # Test1
	# BTCPK="FF5BC0E321913B269A28A441799353EDF3043E67FA1AE3285A66A5D8D71FD49E"
	# BTCPBK="040D6A9F84438B8E9F3F2A99C4985D566F74EBF9D8136472A0EE2165B2324FE42453F492E700BB3446B97295DF310DA85999BBAA16C97B0C73B046062CF37CCC36"
	# BTCPBKC="020D6A9F84438B8E9F3F2A99C4985D566F74EBF9D8136472A0EE2165B2324FE424"
	# # Should Yield
	# # Private Key WIF (Uncompressed)      5KkkNNy8rdoYYiFXyys69khmsVoFEMzdQKPbwVq2id6FdyXNKnH
	# # Private Key WIFC (Compressed)       L5n6RMxmg5SSEy59kVz5jdty3t77oyfMfvAmDYEzaiJBbwayxrHX
	# # Address                             19uq2x8n8UqTtPdKz5KoR2QYvph3x5WwSm
	# # Address (Compressed)                152LnUeEbZtcC9SdEbNvL8ffwCZvBPPHnq

	# # Test2
	# BTCPK="976602DDF8223B4E8049241D265CBE1A2F12A5A0F1F76B6A1E479F5291D7588C"
	# BTCPBK="04769A156C2EF07DE0CCB6C0C6642701A608F4A34C42DDCF046A29A32EFFBE25704708C4AEE561D3523ADDD3C6649342829CF3874AC53F87BA6888D5DA826B4257"
	# BTCPBKC="03769A156C2EF07DE0CCB6C0C6642701A608F4A34C42DDCF046A29A32EFFBE2570"
	# # Should Yield
	# # Private Key WIF (Uncompressed)      5JxxrQ7Te8zoZ6Cgpbjww73uPkdG2aL1i4PcfSYegErtG4bhPpw
	# # Private Key WIFC (Compressed)       L2J1X31WavJ8Udxam6LZTohpFRZ3Kx6v8DxpQfkhJCBBFPRZxy6z
	# # Address                             1GEEEJvmLX9YRvs75PjguVZcvVm4kRGw9p
	# # Address (Compressed)                15ScAkQsdKnDA6uRKqTq8kXXVR4hkeLwDi

	# # Test3
	# BTCPK="D822BEBB41CFF9B34B88E1C6369F5878A4CD89E5FB392BA99D85206AE61FF95B"
	# BTCPBK="046C9E7DF13DAC2D62EE36A5605D3E858CBA5562F7F87A0E9B595BD7F17A1AA21CB3E2CE477045AE9A592D986AD21B738DE72F6FF90AB7C3322C737DDD64B23730"
	# BTCPBKC="026C9E7DF13DAC2D62EE36A5605D3E858CBA5562F7F87A0E9B595BD7F17A1AA21C"
	# # Should Yield
	# # Private Key WIF                     5KTUUhokg8Siiap5MZEZTKFKdUDq2xG8FAzjmvnLyZiagiru6BW
	# # Private Key WIFC (Compressed)       L4TrHH7MmhrX8YEnDjGrF9YDDy9d1cukyZ7qoJP9AfQXfwVYBuKr
	# # Address                             1JGnS3WeM5Eu6K7VxfVk4hVvDVNcmFDEcq
	# # Address (Compressed)                16ny2psCXYrjPjsUqoupTYG48pw8i881wv

	BTCP2="80"$BTCPK
	HASH1="$(echo $BTCP2 | xxd -r -p - | gsha256sum | head -c 64)"
	HASH2="$(echo $HASH1 | xxd -r -p - | gsha256sum | head -c 64)"
	MAGIC="$(echo $HASH2 | head -c 8)"
	PRIVATEWIF="$(encodeBase58 $BTCP2$MAGIC)"

	BTCP2C="80"$BTCPK"01"
	HASH1C="$(echo $BTCP2C | xxd -r -p - | gsha256sum | head -c 64)"
	HASH2C="$(echo $HASH1C | xxd -r -p - | gsha256sum | head -c 64)"
	MAGICC="$(echo $HASH2C | head -c 8)"
	PRIVATEWIFC="$(encodeBase58 $BTCP2C$MAGICC)"

	AHASH1=$(echo -n $BTCPBK | xxd -r -p - | gsha256sum | head -c 64)
	AHASH2=$(echo -n $AHASH1 | xxd -r -p - | openssl dgst -rmd160 -binary | xxd -p)
	VERBYT=00$AHASH2
	AHASH3=$(echo -n $VERBYT | xxd -r -p - | gsha256sum | head -c 64)
	AHASH4=$(echo -n $AHASH3 | xxd -r -p - | gsha256sum | head -c 64)
	CHKSUM=$(echo -n $AHASH4 | head -c 8)
	BTCADDR="$(encodeBase58 $VERBYT$CHKSUM)"

	ACHASH1=$(echo -n $BTCPBKC | xxd -r -p - | gsha256sum | head -c 64)
	ACHASH2=$(echo -n $ACHASH1 | xxd -r -p - | openssl dgst -rmd160 -binary | xxd -p)
	CVERBYT=00$ACHASH2
	ACHASH3=$(echo -n $CVERBYT | xxd -r -p - | gsha256sum | head -c 64)
	ACHASH4=$(echo -n $ACHASH3 | xxd -r -p - | gsha256sum | head -c 64)
	CCHKSUM=$(echo -n $ACHASH4 | head -c 8)
	BTCADDRC="$(encodeBase58 $CVERBYT$CCHKSUM)"
	

	# echo "Private Key: "$PK
	# echo "Public Key: "$PBK
	# echo "Public Key (Compressed): "$PBKC
	
	echo "BitCoin Private Key                   " $BTCPK
	echo "BitCoin Public Key                    " $BTCPBK
	echo "BitCoin Public Key (Compressed)       " $BTCPBKC
	echo ""
	echo "BitCoin Private key WIF               " $PRIVATEWIF
	echo "BitCoin Private key WIFC (Compressed) " $PRIVATEWIFC
	echo "BitCoin Address                       " $BTCADDR
	echo "BitCoin Address (Compressed)          " $BTCADDRC

	printf $BTCPK > $BITCOIN_P
	printf $BTCPBK > $BITCOIN_PB
	printf $BTCPBKC > $BITCOIN_PBC
	printf $PRIVATEWIF > $BITCOIN_WIF
	printf $PRIVATEWIFC > $BITCOIN_WIFC
	printf $BTCADDR > $BITCOIN_ADDR
	printf $BTCADDRC > $BITCOIN_ADDRC

	echo "Files created!"
}

if [ -n "$1" ]; then
	
	FILE_NAME=$1
	
	KEYDIR="./keys"
	FPATH=${KEYDIR}/${FILE_NAME}
	
	mkdir -p ${FPATH}
	
	PRIVATE_KEY=${FPATH}/private.pem
	PUBLIC_KEY=${FPATH}/public.pem
	PUBLIC_KEY_COMPRESSED=${FPATH}/public_compressed.pem
	
	BITCOIN_P=${FPATH}/btc_private.key
	BITCOIN_PB=${FPATH}/btc_public.key
	BITCOIN_PBC=${FPATH}/btc_public_compressed.key
	
	BITCOIN_ADDR=${FPATH}/btc_address.txt
	BITCOIN_ADDRC=${FPATH}/btc_address_compressed.txt
	
	BITCOIN_WIF=${FPATH}/btc_wif.key
	BITCOIN_WIFC=${FPATH}/btc_wif_compressed.key
	
	genkey
else
	echo "usage: btckeygen.sh keyname"
fi