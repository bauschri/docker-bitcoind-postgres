#!/bin/bash

echo "clone repos"
git clone --quiet git@github.com:bitcoin-abe/bitcoin-abe.git
git clone --quiet git@github.com:c0achmcguirk/docker-bitcoin-abe.git
git clone --quiet git@github.com:kylemanna/docker-bitcoind.git

echo "create data-directories"
mkdir ./data-bitcoind
mkdir ./data-bitcoin-abe

echo "copy custom - bitcoin-abe"
cp ./postgres.conf ./docker-bitcoin-abe
cp ./run.server.sh ./docker-bitcoin-abe
cp ./Dockerfile-bitcoin-abe ./docker-bitcoin-abe/Dockerfile

echo "copy custom - bitcoind"
cp ./Dockerfile-bitcoind ./docker-bitcoind/Dockerfile

echo "docker build"
docker-compose build
