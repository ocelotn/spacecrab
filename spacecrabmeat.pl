#! /opt/local/bin/perl -wT
use strict;
use lib qw(.);
use spacecrab;

my $startnode = 0;

#init
my $nodeno = ($ARGV[0])?$ARGV[0]:$startnode;
#my $page = SpaceCrab->getPage($nodeno);
my $page = SpaceCrab->grabNode($nodeno);
print "Content-type:text/html\r\n\r\n";
print $page;

1;
