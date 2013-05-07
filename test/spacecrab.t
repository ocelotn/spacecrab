#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests => 25;
use Test::Exception;
use Text::Diff;
#use Test::Differences;
#use WebService::Validator::HTML::W3C
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
#       getcleannodeno
#		normal conditions
        ok(SpaceCrab::getCleanNodeno('node4a3bq') eq 'node4a3bq', "getCleanNode handles valid node");
        ok(SpaceCrab::getCleanNodeno('node2.node') eq 'node2', "getCleanNode handles node with suffix - DWIM");
	ok(!defined SpaceCrab::getCleanNodeno('2'), "getCleanNode handles node - no prefix, no suffix");
#		problem conditions
        ok(!defined SpaceCrab::getCleanNodeno(), "getCleanNode handles lack of args");
        ok(!defined SpaceCrab::getCleanNodeno(''), "getCleanNode handles empty string");
	ok(!defined SpaceCrab::getCleanNodeno('nodeasdflkajfd10980qw0ersdfjlasdfasdfasdfasdfsdfasdfasdfasdfasdfasdfasdfasdf'), "getCleanNode handles invalid node - overlong");
	ok(!defined SpaceCrab::getCleanNodeno('node2\\3f45'), "getCleanNode handles invalid node - bad chars");

#	grabSnippet
#		normal conditions
	ok(defined SpaceCrab::grabSnippet($cfg->{"storypath"}.'node1.node'), "grabSnippet returns");
	ok(SpaceCrab::grabSnippet($cfg->{"storypath"}.'nodeminimal.node') eq snarfFile($cfg->{"storypath"}.'nodeminimal.node'), "grabSnippet returns file requested");
#		error conditions
	ok(SpaceCrab::grabSnippet("boguspath") eq $cfg->{"text400"}, "returns standard error content on nonexistant path");	

# 	parsenode 
	my $minimalnodetext = '<div class="story" mg="MG2e"><p> text <a href="" data-dest1="node2">choice</a></p></div>';	
	my $attribs = SpaceCrab::parseNode($minimalnodetext);
	
	ok(defined $attribs && ref($attribs) eq "HASH", "parsenode returns a hashref from a valid node text");
	ok('FG1' eq $attribs->{"fg"}, "parsenode returns the default image where none is specified");
	ok('MG2e' eq $attribs->{"mg"}, "parsenode returns the specified image where one is specified");
	
	ok($attribs->{'href'} eq 'spacecrab.pl?node2', "parsenode returns stripped down node link for dest1");
	$minimalnodetext = '<div class="story" mg="MG2e"><p> text <a href="" data-dest2="node2.node">choice</a></p></div>';	
	$attribs = SpaceCrab::parseNode($minimalnodetext);
	
	ok($attribs->{'href'} eq 'spacecrab.pl?node2', "parsenode returns stripped down node linke for dest1 - handle previous format");

#	grabNode
#		normal conditions
	ok(snarfFile($cfg->{'testdata'}.'story/nodeminimal.node'), "returns node contents for valid (prefixed) node");
	ok(SpaceCrab::grabNode('nodeminimal') eq snarfFile($cfg->{'testdata'}.'story/nodeminimal.node'), "returns DWIM contents for valid, prefixed and suffixed node");
#		error conditions
	ok(SpaceCrab::grabNode('minimal') eq $cfg->{"text400"}, "Tidy error for bare node number");
	ok(SpaceCrab::grabNode('\\\\109283712347254JHSDF.123489') eq $cfg->{"text400"}, "Tidy error for blatantly bogus node id");
	ok(SpaceCrab::grabNode('nodebogon') eq $cfg->{"text400"}, "Tidy error for plausible but nonexistant node");
	
#	getPage
#		normal conditions
	ok(length(SpaceCrab::getPage('node2')) == 1753, "get page for valid node returns a string");
	
	print Text::Diff::diff(\(SpaceCrab::getPage('node2')), $cfg->{'testdata'}.'story/node2.node');
#		error conditions

exit;

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

