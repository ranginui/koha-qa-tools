#!/bin/bash

if [ $# -ne 3 ]; then
  echo 1>&2 Usage: $0 path/to/git/repo path/to/koha-install-log opacurl
  exit 127
fi

# change to git repo
cd $1

#clean up so we do a fresh make
if make clean; then
  echo "Cleaned up previous make";
else 
  echo "Clean not needed";
fi

# clean up dir
git clean -f

if git fetch; then
  if git rebase origin; then
    perl Makefile.PL --prev-install-log $2
    make
    make test
  fi
fi

if make install; then
  wget --delete-after $3 2>&1 | grep "/cgi-bin/koha/maintenance.pl"
else
  echo "Can't install";
  exit 127
fi

