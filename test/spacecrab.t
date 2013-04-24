#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests => 10;
#use Test::Differences;
use spacecrabcfg;
use File::Slurp;
use LWP::Simple;
my $cfg= spacecrabcfg::config();

sub getWebContent {
	my $node = "".shift;
	my $url = $cfg->{"baseurl"}.$cfg->{"spacecrab"}."?".$node;
	my $content = get($url) 
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

# use visual inspection to validate css and header/content changes
# then rung testdataGen.pl 

#spacecrab pl

#normal conditions

	ok(snarfFile($cfg->{"testdata"}."combined_nodes/0.html") 
		eq getWebContent(""), 
		"web srvr returns node ".$cfg->{"startnode"}." if no node specified"
	); #default case is correct case and handled and server returns valid page
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/0.html") 
		eq getWebContent(0), 
		"web srvr handles node spec 0"
	); #spacecrab is not confused by bool value of node id 0
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/1.html") 
		eq getWebContent(1), 
		"web srvr handles node spec 1"
	); #spacecrab is not confused by bool value of node id 1
		
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/1.html") 
		eq getWebContent("1".$cfg->{"storysuffix"}), 
		"srvr DWIM w/ node spec w/ terminal ".$cfg->{"storysuffix"}
	); #spacecrab DWIM when handed a node file name isntead of a node id

#error conditions

	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent(12345690), 
		"web srvr handles missing file with correct error"
	); #spacecrab gives correct error on non-existent but valid id
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("somestring"), 
		"handles invalid fname with error - string"
	); #invalid ID condition
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("a2"), 
		"handles invalid fname with error - string w/ number"
	); #invalid ID condition
	
	#eq_or_diff snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html"), getWebContent("a2"), "testing node 1";
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("2hats"), 
		"handles invalid fname with error - num w/ misc string"
	); #invalid ID condition
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("abcdefghijklmnopqrstuvwxyz1234567890"), 
		"web srvr handles invalid fname with correct error - length"
	); #invalid ID condition
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent('\ ;\\\')(*&)@#($*&@(#$"'), 
		"web srvr handles invalid fname with correct error - rubbish"
	); #invalid ID condition
