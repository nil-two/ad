.PHONY: all build test

all:

build:
	bash script/embed_appscript.bash

test: build
	bats test
