#!/bin/bash

# USAGE
# ./terraform.sh ls|tag

REPO=https://github.com/hashicorp/terraform
ZIP=./tmp/terraform_linux_amd64.zip
BINARY=terraform
DEST=/usr/local/bin/$BINARY

if test -z $1; then
  echo missing arg
  exit 1
fi

CURRENT=$(terraform --version | head -n 1 | cut -d " " -f 2)

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
  VERSION=$(tr -d v <<<$1)
  curl -s "https://releases.hashicorp.com/terraform/$VERSION/terraform_${VERSION}_linux_amd64.zip" -o $ZIP
  unzip -d . $ZIP
  rm -v $ZIP
  test -e $DEST && sudo rm -v $DEST
  sudo mv -iv $BINARY $DEST
  echo "* installed version"
  terraform --version
  exit 0
fi

echo bad arg
exit 1
