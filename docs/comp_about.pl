#!/usr/bin/perl

# Copyright 2011 Rijksmuseum
#
# This file is part of Koha.
#
# Koha is free software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# Koha is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with Koha; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

# This script prints the names of all new developers in history.txt, not found
# in about template (English version).

use strict;
use warnings;

use utf8;
use open  OUT=>':utf8', ":std";
use Encode;

use constant HISTORY => '../docs/history.txt';
use constant ABOUT_T => '../koha-tmpl/intranet-tmpl/prog/en/modules/about.tt';

my ($fh_about, $fh_history, $about_cont, $about_cont2, $lastnum);

#-------------------------------------------------------------------------------

init_vars();
show_new_committers();
exit_stuff();

#-------------------------------------------------------------------------------

sub init_vars {
  open $fh_about, '<:encoding(UTF-8)', ABOUT_T or die $!;
  open $fh_history, '<:encoding(UTF-8)', HISTORY or die $!;

  my @a=<$fh_about>;
  $about_cont= join '', @a;
  if ($about_cont=~/id=\"team\"(.*)id=\"licenses\"/s ) {
    $about_cont= $1;
  }
  else {
    print "WARNING: Check about template for div ids\n";
  }
  $about_cont2= $about_cont;
  $about_cont2=~ tr/áéíóúàèìòùäëïöü/aeiouaeiouaeiou/; #remove some diacritics
}

sub show_new_committers {
  my @lines= <$fh_history>;

  foreach(@lines) {
    if(/becomes?.*(developer|committer)/) {
      my $dev=extract_name($_);
      check_developer($dev) if $dev;
    }
  }
}

sub extract_name {
  #get name from line
  #format looks like date name becomes ..
  my $line=shift;
  if($line=~/^\w+\s+\d+\s+\d{4}\s+(.*)become\D+(\d+)/) {
    my $found=$1; my $num=$2;
    print "MISSING NUMBER: ".($lastnum+1)."\n" if $lastnum && $num>$lastnum+1 && $lastnum>5; #first five not all mentioned?
    $lastnum=$num;

    #strip some garbage
    $found=~s/\(.*\)//g;
    $found=~s/narrowly beats Jane to//;
    $found=~s/Katipo.s new developer//;
    $found=~s/^\s+//;
    $found=~s/\s+$//;
    #print "$num $found\n";

    return "$found";
  }
  print 'NO MATCH:'.$line;
}

sub check_developer {
  my $dev= shift;
  my $test;

  #skip some names
  return if $dev=~/Polytechnic University|NCE|Koha production|Andy\?\?|doXulting|Gavin \?\?|Nicole Engard/; #tt lists Nicole C. Engard

  return if index(lc $about_cont,lc $dev) >=0; #lowercase

  #test removing some diacritics?
  $test= $dev;
  $test=~ tr/áéíóúàèìòùäëïöü/aeiouaeiouaeiou/;
  #return if index(lc $about_cont,lc $test) >=0;
  return if index(lc $about_cont2, lc $test) >=0;

  #remove middle initials
  #$test=$dev;
  #$test=~s/(?<=\s)[A-Z]\.\s//;
  #return if index(lc $about_cont,lc $test) >=0;

  print "MISSING DEV: $dev\n";
}

sub exit_stuff {
  close $fh_about;
  close $fh_history;
}

