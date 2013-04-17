#!/usr/bin/perl
use Test::Simple tests => 1;
use SpaceCrab;
my $foo = SpaceCrab->getPage(0);
ok($foo); #we connected to the module and it returned
