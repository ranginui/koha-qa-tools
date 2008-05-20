#!/usr/bin/perl

# Copyright 2008 
# Chris Cormack chris@bigballofwax.co.nz

# This is designed to test an opac is working
# To be run as part of koha-git-upgrade.sh

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

use Test::More tests => 2;
use Test::WWW::Mechanize;
use strict;

my $mech = Test::WWW::Mechanize->new();

$mech->get_ok($ARGV[0]);
$mech->content_contains("Welcome to Koha","We are at the front page of the opac");