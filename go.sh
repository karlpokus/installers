#!/bin/bash

# USAGE (x.y.z)
# ./go.sh version

VERSION=$1

if test -z $VERSION; then
  echo missing arg
  exit 1
fi

FILE="go$VERSION.linux-amd64.tar.gz"
URL="https://go.dev/dl/$FILE"

echo "* installing go $VERSION"

if test -e tmp/$FILE; then
  echo "file already downloaded"
else
  echo "downloading file"
  curl -sSL $URL -o tmp/$FILE
fi

echo "old version $(go version | cut -d " " -f 3)"

sudo rm -rf /usr/local/go > /dev/null && sudo tar -C /usr/local -xzf tmp/$FILE

echo "new version $(go version | cut -d " " -f 3)"
echo "* done"
