DIST_JS = ./dist/ember-i18n.js
JSHINT  = ./node_modules/jshint/bin/jshint

dist: $(DIST_JS)
	$(JSHINT) $<

ci: test

$(DIST_JS): jshint
	mkdir -p dist
	echo "(function() {" | cat - lib/plurals.js lib/i18n.js > $@
	echo "}());" >> $@

jshint: npm_install
	$(JSHINT) lib/*.js spec/*Spec.js

test_ember_10: dist npm_install
	JQUERY_VERSION=1.9.1 EMBER_VERSION=1.0.0 ./spec/buildSuite.js
	./node_modules/mocha-phantomjs/bin/mocha-phantomjs spec/suite.html

test: test_ember_10

npm_install:
	npm install

clean:
	rm -f spec/suite.html

.PHONY: dist ci jshint test test_ember_10 npm_install clean
