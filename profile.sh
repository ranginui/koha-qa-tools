#!/bin/bash

# Copyright 2008 
# Chris Cormack chris@bigballofwax.co.nz

# This is designed to profile the koha code
# It expects a working koha and Devel::NYTProf

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

if [ $# -ne 2 ]; then
  echo 1>&2 Usage: $0 path/to/git/repo path/to/koha-conf.xml
  exit 127
fi

export KOHA_CONF=$2

perl -I$1 -d:NYTProf $1/mainpage.pl
nytprofhtml