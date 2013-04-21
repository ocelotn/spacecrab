#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests =>2;
use spacecrabcfg;
use File::Slurp;
use LWP::Simple;
my $cfg= spacecrabcfg::config();


my $head = 'Content-type:text/html

';

sub getWebContent {
	my $node = "".shift;
	my $content = get($cfg->{"baseurl"}.$cfg->{"spacecrabmeat"}."?".$node) 
    or die "Couldn't get ".$cfg->{"baseurl"}." - $!";
	return $content;
}

sub snarfFile {
	my $fpath= shift;
	my $content = "";
	$content .= File::Slurp::read_file($fpath);
	return $content;
}

sub dirlist {
	my $dpath = shift;
	opendir (DH, $dpath);
	my @dlist = <DH>;
	close DH;
	return \@dlist;	
}

#normal conditions
ok(snarfFile($cfg->{"testdata"}."story/0.node") 
	eq getWebContent(""), 
	"web srvr returns node ".$cfg->{"startnode"}." if no node specified"
); #default case is correct case and handled and server returns valid page

ok(snarfFile($cfg->{"testdata"}."story/0.node") 
	eq getWebContent(0), 
	"web srvr handles node spec 0"
); #spacecrab is not confused by bool value of node id 0

ok(snarfFile($cfg->{"testdata"}."combined_nodes/1.node") 
	eq getWebContent(1), 
	"web srvr handles node spec 1"
); #spacecrab is not confused by bool value of node id 1
