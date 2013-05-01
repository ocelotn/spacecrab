#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests => 10;
#use Test::Differences;
use spacecrabcfg;
use spacecrab;
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


#spacecrab pm
# 	parsenode 
	my $minimalnodetext = '<div class="story" mg="MG2e"><p> text <a href="" dest1="node2">choice</a></p></div>';	
	my $images = SpaceCrab::parseNode($minimalnodetext);
	
	ok(defined $images && ref($images) eq "HASH", "parsenode returns a hashref from a valid node text");
	ok('FG1' eq $images->{"fg"}, "parsenode returns the default image where none is specified");
	ok('MG2e' eq $images->{"mg"}, "parsenode returns the specified image where one is specified");

#spacecrab web tests - only works for features pushed to test server! 

#normal conditions 

	ok(snarfFile($cfg->{"testdata"}."combined_nodes/".$cfg->{"startnode"}.".html") 
		eq getWebContent(""), 
		"web srvr returns node ".$cfg->{"startnode"}." if no node specified"
	); #default case is correct case and handled and server returns valid page
	
	#TEST NOT RELEVANT UNDER CURRENT NODESPEC - RESTORE IF USING PURE NUMERIC
	#ok(snarfFile($cfg->{"testdata"}."combined_nodes/0.html") 
	#	eq getWebContent(0), 
	#	"web srvr handles node spec 0"
	#); #spacecrab is not confused by bool value of node id 0
        #	
	#ok(snarfFile($cfg->{"testdata"}."combined_nodes/1.html") 
	#	eq getWebContent(1), 
	#	"web srvr handles node spec 1"
	#); #spacecrab is not confused by bool value of node id 1
		
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/node2.html") 
		eq getWebContent("node2".$cfg->{"storysuffix"}), 
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
		"handles invalid fname with error - w/o node prefix"
	); #invalid ID condition
	
	#eq_or_diff snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html"), getWebContent("a2"), "testing node 1";
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("abcdefghijklmnopqrstuvwxyz1234567890"), 
		"web srvr handles invalid fname with correct error - length"
	); #invalid ID condition
	
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent('\ ;\\\')(*&)@#($*&@(#$"'), 
		"web srvr handles invalid fname with correct error - rubbish"
	); #invalid ID condition
