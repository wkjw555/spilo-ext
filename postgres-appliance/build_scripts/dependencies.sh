#!/bin/bash

## ------------------
## Dependencies magic
## ------------------

set -ex

# should exist when $DEMO=TRUE to avoid 'COPY --from=dependencies-builder /builddeps/wal-g ...' failure

if [ "$DEMO" = "true" ]; then
    mkdir /builddeps/wal-g
    exit 0
fi

export DEBIAN_FRONTEND=noninteractive
MAKEFLAGS="-j $(grep -c ^processor /proc/cpuinfo)"
export MAKEFLAGS
ARCH="$(dpkg --print-architecture)"

echo -e 'APT::Install-Recommends "0";\nAPT::Install-Suggests "0";' > /etc/apt/apt.conf.d/01norecommend

go version
#go env -w GO111MODULE=on
#go env -w GOPROXY=https://goproxy.cn,direct

git clone -b "$WALG_VERSION" --recurse-submodules https://github.com/wal-g/wal-g.git
cd /wal-g
go get -v -t -d ./...
go mod vendor
