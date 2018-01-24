OSSLPATH="/usr/local/Cellar/openssl@1.1/1.1.0e"

build:
	gcc blockgen.c -I$(OSSLPATH)/Include -L$(OSSLPATH) -lssl -lcrypto -o blockgen.bin
	chmod +x blockgen.bin

btc:
	gcc blockgenSatoshi.c -I$(OSSLPATH)/Include -L$(OSSLPATH) -lssl -lcrypto -o blockgenSatoshi.bin
	chmod +x blockgenSatoshi.bin