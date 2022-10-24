#!/bin/bash

# USAGE
# ./gh.sh ls|tag

REPO=https://github.com/cli/cli
DEST=/usr/local/bin/gh

if test -z $1; then
  echo missing arg
  exit 1
fi

CURRENT=$(gh version | head -n 1 | cut -d " " -f 3)

if test $1 = "ls"; then
  echo "current version is $CURRENT"
  gh release list -R $REPO
  exit 0
fi

if test $(grep "^v" <<<$1); then
  echo "* installing gh $1"
  VERSION=$(tr -d v <<<$1)
  PKG="gh_${VERSION}_linux_amd64.tar.gz"
  BINARY=tmp/gh_${VERSION}_linux_amd64/bin/gh
  if test -e tmp/$PKG; then
    echo "file already downloaded"
  else
    echo "* downloading $1"
    gh release download $1 -p $PKG -R $REPO -D tmp
  fi
  tar -C tmp -xzf tmp/$PKG
  test -e $DEST && sudo rm -v $DEST
  sudo mv -iv $BINARY $DEST
  echo "* installed version"
  gh version | head -n 1
  exit 0
fi

echo bad arg
exit 1
