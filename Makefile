.PHONY: all build test

all:

build:
	bash script/embed_appscript.bash

lint:
	@bash script/lint.bash

test: build
	bats test
