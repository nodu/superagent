
TESTS = test/node/*.js
REPORTER = dot

all: superagent.js

test:
	@NODE_ENV=test NODE_TLS_REJECT_UNAUTHORIZED=0 ./node_modules/.bin/mocha \
		--require should \
		--reporter $(REPORTER) \
		--timeout 5000 \
		--growl \
		$(TESTS)

test-cov: lib-cov
	SUPERAGENT_COV=1 $(MAKE) test REPORTER=html-cov > coverage.html

test-browser-local:
	./node_modules/.bin/zuul --local 4000 -- test/index.js

lib-cov:
	jscoverage lib lib-cov

superagent.js: lib/node/*.js lib/node/parsers/*.js
	@./node_modules/.bin/browserify \
		--standalone superagent \
		--outfile superagent.js .

test-server:
	@node test/server

docs: test-docs

test-docs:
	make test REPORTER=doc \
		| cat docs/head.html - docs/tail.html \
		> docs/test.html

clean:
	rm -fr superagent.js components

.PHONY: test-cov test docs test-docs clean
