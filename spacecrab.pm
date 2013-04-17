#! /usr/local/bin/perl
use strict;
use warnings;
package SpaceCrab;

#config
my $startnode = 0;
my $storypath = "../spacecrab/testdata/story/";
my $boilerplatepath = "../spacecrab/boilerplate/";
my $headername = "header.html";
my $footername = "footer.html";
my $storysuffix = ".node";

#methods
sub grabSnippet{
	my $filepath = $_[0];
	open(my $fh,"<", $filepath) or return "No such content found for $filepath: $!";
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
	
	return $wodgeoftext;
}

sub getPage {
	my $nodeno = $_[1];
	#add boilerplate
	my $page;
	#	add header
	$page.=grabSnippet($boilerplatepath.$headername);
	#	add story
	$page.=grabSnippet($storypath.$nodeno.$storysuffix);
	#	add footer
	$page.=grabSnippet($boilerplatepath.$footername);
	
	#return data
	return $page;
}

1;
