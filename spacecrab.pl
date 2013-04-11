#! /usr/bin/perl
use strict;
use warnings;
use SpaceCrab;

my $startnode = 0;

#init
my $nodeno = ($ARGV[0])?$ARGV[0]:$startnode;
my $page = SpaceCrab->getPage($nodeno);
print $page;

1;
