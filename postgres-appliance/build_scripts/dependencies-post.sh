#!/bin/bash

## ------------------
## Dependencies magic
## ------------------

set -ex

cd /wal-g
bash link_brotli.sh
bash link_libsodium.sh

export USE_LIBSODIUM=1
export USE_LZO=1
make pg_build

# We want to remove all libgdal30 debs except one that is for current architecture.
printf "shopt -s extglob\nrm /builddeps/!(*_%s.deb)" "$ARCH" | bash -s

mkdir /builddeps/wal-g

cp /wal-g/main/pg/wal-g /builddeps/wal-g/
