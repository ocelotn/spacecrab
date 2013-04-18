#! /usr/local/bin/perl
use strict;
use warnings;

use Test::Simple tests=>2;
use LWP::Simple;

my $nodesuffix = ".node";
my $url = "http://test.space-crab.com/spacecrabmeat?";
my $execpath = "./spacecrabmeat.pl";
my $testdatapath = "testdata/story/"; 
my $head = 'Content-type:text/html

';
#open (my $fh, "<", $testdatapath.'0'.$nodesuffix) or die "cannot find file";
open (my $fh, "<", "test0") or die "cannot find file";
my $tomatch="";
while(<$fh>){$tomatch.=$_;}
close $fh;
print $tomatch;
ok($tomatch eq get $url);
ok($head.$tomatch eq `perl $execpath`);

