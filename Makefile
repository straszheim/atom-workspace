ROOT_DIR := $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
BIN_DIR := $(ROOT_DIR)/bin

# per the docs this also had rpm and fakeroot
pkgdeps:
	sudo apt-get install build-essential git libsecret-1-dev libx11-dev libxkbfile-dev

node/Makefile: node/configure pkgdeps
	cd node ; ./configure --prefix=$(ROOT_DIR)

node/node: node/Makefile
	make -C node -j5

$(ROOT_DIR)/bin/node $(ROOT_DIR)/bin/npm $(ROOT_DIR)/bin/npx: node/node
	make -C node install

installed: $(BIN_DIR)/node

# this is for atom hacky thing
configured: $(BIN_DIR)/node
	$(BIN_DIR)/bin/npm config set python /usr/bin/python2 -g

.ONESHELL:
check: $(BIN_DIR)/node $(BIN_DIR)/npm $(BIN_DIR)/npx
	. $(ROOT_DIR)/env.sh
	$(BIN_DIR)/node --version
	$(BIN_DIR)/npm --version
	$(BIN_DIR)/npx --version

.ONESHELL:
atom_bootstrap:
	# this is to deal with https://github.com/atom/atom/issues/15164
	# weird ansicolors pkg error
	. $(ROOT_DIR)/env.sh
	cd atom
	./script/bootstrap
	find . -name package-lock.json -exec rm {} \;

.ONESHELL:
atom_install:
	. $(ROOT_DIR)/env.sh
	cd atom
	./script/build --install=$(ROOT_DIR)
