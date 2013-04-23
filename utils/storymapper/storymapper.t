#!/usr/bin/perl
use strict;
use warnings;
use Test::Simple tests=>19;

use Mojo::DOM;
use StoryMapper;

my $realfile = "1.node";
my $nonexfile = "23.node";
my $emptyfile = "emptynode.node";

#MOVE STORYMAPPER CONFIG TO VARIABLE LOC FOR USE WITH TESTS...

#testing getNodeFromFileName
print "\nTesting getNodeFromFileName\n\n";
ok("23" eq getNodeFromFileName($nonexfile), "Extracting simple numeric nodename"); 
ok("somestring" eq getNodeFromFileName("somestring.node"),
	"Extracting string-based node name");
ok('123_458\ happy cat-' eq getNodeFromFileName('123_458\ happy cat-.node')
	,"Extracting complex string-based node name");
ok("-1" eq getNodeFromFileName('hasdfn.nod'), "Extracting from invalid name format");

#testing getFirstLine
print "\nTesting getFirstLine\n\n";

#	should return ok
my $domWellFormedShortH2 = Mojo::DOM->new->parse('<div class="story"><h2>Title</h2><p>Some text that goes on\n and one and ... on.</p></And another line.\n');
ok('Title' eq getFirstLine($domWellFormedShortH2),"Get first-line from valid string");

my $domWellFormedLongP = Mojo::DOM->new->parse('<div class="story"><p>Someone\'s long text that goes and and one and one ansdfsaf asfjslfjj asfsfdsaf summa awiilum ina biit abiisha etc etc and if he should steal his neighbor\'s door, that would be a bad thing; if he should write it all out in cuneiform, that would be a lot of work.</p></div>');
ok('Someone\'s long text that goes and and one and one ' eq getFirstLine($domWellFormedLongP),"Get first-line from valid string, truncated");

my $domWellFormedLongPPunctuated = Mojo::DOM->new->parse('<div class="story"><p>Someone\'s long text; that? goes? on.... that goes and and one and one ansdfsaf asfjslfjj asfsfdsaf summa awiilum ina biit abiisha etc etc and if he should steal his neighbor\'s door, that would be a bad thing; if he should write it all out in cuneiform, that would be a lot of work.</p></div>');

my $domNestedBlocks = Mojo::DOM->new->parse('<div class="story"><ul><li>Text in a list item</li></ul><p>stuff</p></div>');
ok("Text in a list item" eq getFirstLine($domNestedBlocks), "Handle nested block elements prior to first text");
#print getFirstLine($domNestedBlocks)." is domNestedBlocks output \n\n";

#	error cases
my $noTextErrString = "Cannot find a first line. Node may be skeletal.";

my $domEmptyString = Mojo::DOM->new->parse('');
ok($noTextErrString eq getFirstLine($domEmptyString),
	,"Get first-line substitute from empty string");
	
my $domEmptyDiv = Mojo::DOM->new->parse('div class="story"></div>');
ok($noTextErrString eq getFirstLine ($domEmptyDiv),
	,"Get first-line substitute from empty div");

my $domBareTextInDiv = Mojo::DOM->new->parse('<div class="story">Some bare text.</div>');
ok(getFirstLine($domBareTextInDiv) eq $noTextErrString,"Handle file with invalid syntax - BareText");

my $domNoDiv = Mojo::DOM->new->parse('<p>P without enclosing div. Is this a problem?</p>');
ok(getFirstLine($domNoDiv) eq $noTextErrString,"Handle file with invalid syntax - no div");

my $domNoStoryDiv = Mojo::DOM->new->parse('<div><p>P without enclosing div. Is this a problem?</p></div>');
ok(getFirstLine($domNoDiv) eq $noTextErrString,"Handle file with invalid syntax - no story div");

my $domJumbledSyntax = Mojo::DOM->new->parse('<p><div>stuff<p>inner p</ul>');
ok(getFirstLine($domJumbledSyntax) eq $noTextErrString, "Handle file with invalid syntax - jumbled");

#testing snarfFile
print "\nTesting snarfFile\n";
ok(length(snarfFile($realfile)) == 381,"Process populated readable file");
ok(length(snarfFile($emptyfile)) == 0,"Process empty, readable file");
$@ = "";
eval{snarfFile("bogusfile")};
ok($@ ne "","Dies on nonexistent file");

#testing getFileSpec
print "\nTesting getFileSpec\n";
my @dirlist = ('0.node','1.node','2.node','3.node','emptynode.node');
ok(@dirlist eq getFileSpec('../testdata/story/'),"Read populated valid directory");
ok(getFileSpec('../testdata/emptydir') == 0,"Read empty valid directory");

$@ = "";
eval{getFileSpec('bogusdir')};
ok($@ ne "","Die on invalid story dir path");
$@ = "";
eval{getFileSpec('lockeddir')};
ok($@ ne "","Die on unreadable story dir path");

#testing graphing
print "\nTesting Graphing\n";
#compare against known, human validated map for test nodes
	#compare against empty node
	#compare against full Node
	#compare against minimal map for node with single edge
	#compare against minimal map for node with fork

# ok(snarfFile("referenceFile1.svg") ne main(), "Failed to generate valid map file from known test nodes");

ok(0, "Graphing tests outlined but not yet implemented");
 
$@ = "";
ok($@ eq "","testing tests");
