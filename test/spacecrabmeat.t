#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests =>5;
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
ok(snarfFile($cfg->{"testdata"}."story/".$cfg->{"startnode"}.".node") 
	eq getWebContent(""), 
	"web srvr returns node ".$cfg->{"startnode"}." if no node specified"
); #default case is correct case and handled and server returns valid page

ok(snarfFile($cfg->{"testdata"}."story/node1.node") 
	eq getWebContent("node1"), 
	"web srvr handles node spec node1"
);

#error conditions
ok(getWebContent("1") eq $cfg->{"text400"},
	"web srvr errors on prefixless node"
); 
ok(getWebContent("sillyhat") eq $cfg->{"text400"},
	"web srvr errors on prefixless node - string"
); 
ok(getWebContent("nodebogus") eq $cfg->{"text400"},
	"web srvr errors on nonexistent valid nodeid"
); 
