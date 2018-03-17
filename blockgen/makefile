OSSLPATH="/usr/local/Cellar/openssl@1.1/1.1.0e"
all: build
build:
	gcc blockgen.c -I$(OSSLPATH)/Include -L$(OSSLPATH) -lssl -lcrypto -o blockgen.bin
	chmod +x blockgen.bin