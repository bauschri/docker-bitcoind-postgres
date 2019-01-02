.PHONY: build deploy

VERSION=$(shell grep version package.json | cut -d ':' -f2 | sed 's/[", ]//g')

MAJOR      = $(shell echo $(VERSION) | sed "s/^\([0-9]*\).*/\1/")
MINOR      = $(shell echo $(VERSION) | sed "s/[0-9]*\.\([0-9]*\).*/\1/")

BUILD      = $(shell git log --oneline | wc -l | sed -e "s/[ \t]*//g")
NEXT_MAJOR_VERSION = $(shell expr $(MAJOR) + 1).0.0-b$(BUILD)
NEXT_MINOR_VERSION = $(MAJOR).$(shell expr $(MINOR) + 1).0-b$(BUILD)
NEXT_PATCH_VERSION = $(MAJOR).$(MINOR).$(BUILD)

cleanup:
	rm -rf bitcoin-abe
	rm -rf docker-bitcoin-abe
	rm -rf docker-bitcoind

download:
	$(shell [ ! -d ./bitcoin-abe ] 				&& git clone --quiet https://github.com/bitcoin-abe/bitcoin-abe.git)
	$(shell [ ! -d ./docker-bitcoin-abe ] && git clone --quiet https://github.com/c0achmcguirk/docker-bitcoin-abe.git)
	$(shell [ ! -d ./docker-bitcoind ] 		&& git clone --quiet https://github.com/kylemanna/docker-bitcoind.git)

	mkdir -p ./data-bitcoind
	mkdir -p ./data-bitcoin-abe

	cp ./postgres.conf ./docker-bitcoin-abe
	cp ./run.server.sh ./docker-bitcoin-abe
	cp ./Dockerfile-bitcoin-abe ./docker-bitcoin-abe/Dockerfile
	cp ./Dockerfile-bitcoind ./docker-bitcoind/Dockerfile

build:
	docker build --pull -f ./docker-bitcoin-abe/Dockerfile -t cbaus/bitcoin-abe:$(NEXT_PATCH_VERSION) ./docker-bitcoin-abe
	docker push cbaus/bitcoin-abe:$(NEXT_PATCH_VERSION)
	docker tag cbaus/bitcoin-abe:$(NEXT_PATCH_VERSION) cbaus/bitcoin-abe:latest
	docker push cbaus/bitcoin-abe:latest

	docker build --pull -f ./docker-bitcoind/Dockerfile -t cbaus/bitcoin-abe:$(NEXT_PATCH_VERSION) ./docker-bitcoind
	docker push cbaus/docker-bitcoind:$(NEXT_PATCH_VERSION)
	docker tag cbaus/docker-bitcoind:$(NEXT_PATCH_VERSION) cbaus/docker-bitcoind:latest
	docker push cbaus/docker-bitcoind:latest

deploy:
	make cleanup
	make download
	make build
