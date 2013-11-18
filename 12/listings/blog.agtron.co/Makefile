rwildcard = $(wildcard $1$2) $(foreach d,$(wildcard $1*),$(call rwildcard,$d/,$2))

all: build

test: build
	coffee -c -o compiled/spec spec
	compiled = $(call rwildcard, node compiled/spec/, *_spec.js)
	node compiled

build: clean npm client compile
	cp -R content compiled
	tar -cvf artifact.tar compiled

client: compile
	mkdir compiled/app/client
	coffee ./make_client.coffee

npm:
	npm install

compile:
	coffee -c -o compiled/app app

clean:
	rm -rf compiled
