.PHONY: all embed lint test

all:

embed:
	@bash script/embed.bash

lint:
	@bash script/lint.bash

test:
	@bats test
