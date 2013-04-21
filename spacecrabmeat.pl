#!/usr/bin/env perl -wT
use strict;
use lib qw(.);
use spacecrab;
use spacecrabcfg;

my $cfg = spacecrabcfg::config();

#init
my $nodeno = ($ARGV[0])?$ARGV[0]:$cfg->{"startnode"};
my $page = SpaceCrab->grabNode($nodeno);
print "Content-type:text/html\r\n\r\n";
print $page;

1;
