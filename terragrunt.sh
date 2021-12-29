#!/bin/bash

# USAGE
# ./terragrunt.sh ls|tag

REPO=https://github.com/gruntwork-io/terragrunt
BINARY=terragrunt_linux_amd64
DEST=/usr/local/bin/terragrunt

if test -z $1; then
  echo missing arg
  exit 1
fi

CURRENT=$(terragrunt --version | cut -d " " -f 3)

if test $1 = "ls"; then
  echo "current version is $CURRENT"
  gh release list -R $REPO
  exit 0
fi

if test $(grep "^v" <<<$1); then
  if test $1 = $CURRENT; then
    echo "already running $CURRENT"
    exit 0
  fi
  echo "* downloading $1"
  gh release download $1 -p $BINARY -R $REPO
  test -e $DEST && sudo rm -v $DEST
  chmod -v +x $BINARY
  sudo mv -iv $BINARY $DEST
  echo "* installed version"
  terragrunt --version
  exit 0
fi

echo bad arg
exit 1
