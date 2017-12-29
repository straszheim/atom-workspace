ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
NODE=node-v8.9.3

pkgdeps:
	sudo apt-get install build-essiential git libsecret-1-dev fakeroot rpm libx11-dev libxkbfile-dev

$(NODE).tar.gz: pkgdeps
	wget --no-clobber --continue https://nodejs.org/dist/v8.9.3/$@

$(NODE)/configure: $(NODE).tar.gz
	tar xvzf $<

$(NODE)/Makefile: $(NODE)/configure
	cd $(NODE) ; ./configure --prefix=$(ROOT_DIR)

$(NODE)/node: $(NODE)/Makefile
	cd $(NODE) ; make -j5

$(ROOT_DIR)/bin/node: $(NODE)/node
	cd $(NODE) ; make install

installed: $(ROOT_DIR)/bin/node

configured: $(ROOT_DIR)/bin/node
	$(ROOT_DIR)/bin/npm config set python /usr/bin/python2 -g

# now you got node, npm, npx

clean:
	rm -rf $(NODE) $(NODE).tar.gz
