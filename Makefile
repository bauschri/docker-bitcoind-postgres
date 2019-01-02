.PHONY: cleanup download build deploy

PACKAGE_VERSION=$(shell grep version package.json | cut -d ':' -f2 | sed 's/[", ]//g')

MAJOR      = $(shell echo $(PACKAGE_VERSION) | sed "s/^\([0-9]*\).*/\1/")
MINOR      = $(shell echo $(PACKAGE_VERSION) | sed "s/[0-9]*\.\([0-9]*\).*/\1/")

BUILD      = $(shell git log --oneline | wc -l | sed -e "s/[ \t]*//g")
VERSION 	 = $(MAJOR).$(MINOR).$(BUILD)

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
	docker build --pull -f ./docker-bitcoin-abe/Dockerfile -t cbaus/bitcoin-abe:$(VERSION) ./docker-bitcoin-abe
	docker push cbaus/bitcoin-abe:$(VERSION)
	docker tag cbaus/bitcoin-abe:$(VERSION) cbaus/bitcoin-abe:latest
	docker push cbaus/bitcoin-abe:latest

	docker build --pull -f ./docker-bitcoind/Dockerfile -t cbaus/docker-bitcoind:$(VERSION) ./docker-bitcoind
	docker push cbaus/docker-bitcoind:$(VERSION)
	docker tag cbaus/docker-bitcoind:$(VERSION) cbaus/docker-bitcoind:latest
	docker push cbaus/docker-bitcoind:latest

deploy:
	make cleanup
	make download
	make build
