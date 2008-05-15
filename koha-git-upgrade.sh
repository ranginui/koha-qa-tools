#!/bin/bash

# Copyright 2008 
# Chris Cormack chris@bigballofwax.co.nz

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#	    
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#			    
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

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
  if wget --delete-after $3 2>&1 | grep "/cgi-bin/koha/maintenance.pl"; then
    echo "Database upgrade needed";
    exit 127
  else
    echo "Upgrade finished";
  fi
else
  echo "Can't install";
  exit 127
fi

