#!/usr/bin/env perl
use strict;
use warnings;

use lib qw(.);

use Test::More tests => 42;
use Test::Exception;
use Text::Diff;
use Test::Differences;
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
#		problem conditions
	ok(!defined SpaceCrab::getCleanNodeno('2'), "getCleanNode handles node - no prefix, no suffix");
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
	ok('FG1.png' eq $attribs->{"fg"}, "parsenode returns the default image where none is specified");
	ok('MG2e' eq $attribs->{"mg"}, "parsenode returns the specified image where one is specified");
#	ok($attribs->{'href'} eq 'spacecrab.pl?node2', "parsenode returns stripped down node link for dest1");
#		further image testing
	$minimalnodetext = '<div class="story" fg="FGxyzzy" bg="BGxysoemthign"><p> text <a href="" data-dest1="node1" data-dest2="node2.node">choice</a></p></div>';	
	$attribs = SpaceCrab::parseNode($minimalnodetext);
	ok($attribs->{'bg'} eq 'BGxysoemthign', "parsenode returns specified bg image");
	ok($attribs->{'fg'} eq 'FGxyzzy', "parsenode returns specified fg image");
	ok($attribs->{'mg'} eq $cfg->{'mgdefault'}, "parsenode returns default mg image when none specified");
	
	$minimalnodetext = '<div class="story" fg="FG-x\\yzzy"><p> text <a href="" data-dest1id="node1">choice</a></p></div>';
	$attribs = SpaceCrab::parseNode($minimalnodetext);
	ok($attribs->{'fg'} eq $cfg->{'fgdefault'}, "parsenode substitutes default image on invalide image name");
	
###### TEMPORARY - REPLACE WHEN WE HAVE RANDOMIZER ######
###Behaviour with randomizer installed undetermined#####
#	$minimalnodetext = '<div class="story" mg="MG2e"><p> text <a href="" data-dest1="node1" data-dest2="node2.node">choice</a></p></div>';	
#	$attribs = SpaceCrab::parseNode($minimalnodetext);
#	ok($attribs->{'href'} eq 'spacecrab.pl?node1', "parsenode returns stripped down node link for dest2 - handle node suffix");

#	grabNodeData
#		normal conditions
#	ok(SpaceCrab::grabNodeData('nodeminimal')->{'story'} eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1="node1" href="spacecrab.pl?node1">choice</a></p></div>', "Grab node data returns link adjusted node contents for valid node");
	ok(SpaceCrab::grabNodeData('nodeminimal')->{'fg'} eq 'FGminim', "foreground sub working and image name supplied");
	ok(SpaceCrab::grabNodeData('nodeminimal')->{'mg'} eq $cfg->{'mgdefault'}, "midground defaulting correctly");
	ok(SpaceCrab::grabNodeData('nodeminimal')->{'bg'} eq $cfg->{'bgdefault'}, "background defaulting correctly");
	ok(SpaceCrab::grabNodeData('nodeminimalsuffixed')->{'story'} eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1="node1.node">choice</a></p></div>', "Grab node data returns link adjusted node contents for valid but suffixed node");
#	ok(SpaceCrab::grabNodeData('nodeminimalsuffixed')->{'story'} eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1id="node1.node" href="spacecrab.pl?node1">choice</a></p></div>', "Grab node data returns link adjusted node contents for valid but suffixed node");
#		error conditions
	ok(SpaceCrab::grabNodeData()->{'story'} eq $cfg->{'text400'}, "Tidy error on missing node spec in grabNodeData");
	ok(SpaceCrab::grabNodeData('bogon')->{'story'} eq $cfg->{'text400'}, "Tidy error on bogus node spec in grabNodeData");
	ok(SpaceCrab::grabNodeData('123.node')->{'story'} eq $cfg->{'text400'}, "Tidy error on invalid node spec in grabNodeData");
	ok(SpaceCrab::grabNodeData('nodeBogus.node')->{'story'} eq $cfg->{'text400'}, "Tidy error on plausible non-existant node in grabNodeData");

#	grabNode
#		normal conditions
	ok(SpaceCrab::grabNode('nodeminimal') eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1="node1">choice</a></p></div>', "returns node contents for valid (prefixed) node");
#	ok(SpaceCrab::grabNode('nodeminimal') eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1id="node1" href="spacecrab.pl?node1">choice</a></p></div>', "returns node contents for valid (prefixed) node");
#	ok(SpaceCrab::grabNode('nodeminimalsuffixed') eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1id="node1.node" href="spacecrab.pl?node1">choice</a></p></div>', "returns DWIM contents for valid prefixed and suffixed node");
	ok(SpaceCrab::grabNode('nodeminimalsuffixed') eq '<div class="story" fg="FGminim"><p>Some text<a data-dest1="node1.node">choice</a></p></div>', "returns DWIM contents for valid prefixed and suffixed node");
	#		error conditions
	ok(SpaceCrab::grabNode() eq $cfg->{'text400'}, "Tidy error for unspecified node.");
	ok(SpaceCrab::grabNode('minimal') eq $cfg->{"text400"}, "Tidy error for bare node number");
	ok(SpaceCrab::grabNode('\\\\109283712347254JHSDF.123489') eq $cfg->{"text400"}, "Tidy error for blatantly bogus node id");
	ok(SpaceCrab::grabNode('nodebogon') eq $cfg->{"text400"}, "Tidy error for plausible but nonexistant node");

	exit;

#	getPage
#		normal conditions
	ok(length(SpaceCrab::getPage('nodeminimal')) == 1058, "get page for valid node returns a string of correct length for nodeminimal");
	print SpaceCrab::getPage('nodeminimal');
	ok(SpaceCrab::getPage('nodeminimal') eq snarfFile($cfg->{'testdata'}.'story/nodeminimal.local'), "get page for valid node returns correct page");
#check for html validity
#check for matching sample output
#		error conditions
	
#spacecrab web tests - only works for features pushed to test server! 
exit;

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
		eq getWebContent("a2"), 
		"handles invalid fname with error - w/o node prefix"
	); #invalid ID condition
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("node\\\/bogonchar"), 
		"handles invalid fname with error - invalid char"
	); #invalid ID condition
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent("abcdefghijklmnopqrstuvwxyz1234567890"), 
		"web srvr handles invalid fname with correct error - length"
	); #invalid ID condition
	ok(snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html") 
		eq getWebContent('\ ;\\\')(*&)@#($*&@(#$"'), 
		"web srvr handles invalid fname with correct error - rubbish"
	); #invalid ID condition
	
	#eq_or_diff snarfFile($cfg->{"testdata"}."combined_nodes/bogus.html"), getWebContent("a2"), "testing node 1";
	
