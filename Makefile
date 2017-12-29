NODE=node-v8.9.3

$(NODE).tar.gz:
	wget --no-clobber --continue https://nodejs.org/dist/v8.9.3/$@

$(NODE)/configure: $(NODE).tar.gz
	tar xvzf $<

$(NODE)/Makefile: $(NODE)/configure
	cd $(NODE) ; ./configure

configured: $(NODE)/Makefile

clean:
	rm -rf $(NODE) $(NODE).tar.gz
