#!/usr/local/bin/perl
use strict;
use warnings;
use Test::Simple tests=>2;

use LWP::Simple;
my $baseurl = 'http://hills.ccsf.edu/~lortizde/spacecrab.px';

my $content = get($baseurl) or die "Couldn't get $baseurl - $!";
#print "content is ".$content."\n";

#spacecrab pl

my $result = `./spacecrab.pl`;
my $compareto = 1;
print $?;


ok($result eq $compareto, "spacecrab.pl returns correct node 0 doc for request with no params.");

ok($content eq $compareto, "spacecrab.pl returns correct node page for specified node.");
