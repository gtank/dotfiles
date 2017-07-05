#!/bin/bash
# Installs golang dev environment (assumes prior installation of Go in PATH)

set -euxo pipefail

export GOPATH=$HOME/go
export GOROOT_BOOTSTRAP=/usr/lib/golang

mkdir -p /usr/local/golang-dev
git clone https://github.com/golang/go /usr/local/golang-dev
cd /usr/local/golang-dev/src
./make.bash
cd ..
ln -s `pwd`/bin/go /usr/local/bin/go
ln -s `pwd`/bin/gofmt /usr/local/bin/gofmt
