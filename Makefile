.PHONY: all build

all:

build:
	bash script/embed_appscript.bash

test: build
	bats test
