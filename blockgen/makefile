OSSLPATH="/usr/local/Cellar/openssl@1.1/1.1.0e"

build:
	gcc blockgen.c -I$(OSSLPATH)/Include -L$(OSSLPATH) -lssl -lcrypto -o blockgen

btc:
	gcc blockgenbtc.c -I$(OSSLPATH)/Include -L$(OSSLPATH) -lssl -lcrypto -o blockgenbtc