#!/bin/bash

git clone git@github.com:bitcoin-abe/bitcoin-abe.git
git clone git@github.com:c0achmcguirk/docker-bitcoin-abe.git
git clone git@github.com:kylemanna/docker-bitcoind.git


mkdir ./data-bitcoind
mkdir ./data-bitcoin-abe

cp ./postgres.conf ./docker-bitcoin-abe
cp ./run.server.sh ./docker-bitcoin-abe
cp ./Dockerfile-bitcoin-abe ./docker-bitcoin-abe/Dockerfile
cp ./Dockerfile-bitcoind ./docker-bitcoind/Dockerfile
