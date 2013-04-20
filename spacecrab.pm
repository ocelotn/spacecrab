#!/usr/bin/env perl -wT
use strict;
package SpaceCrab;

#config
my $startnode = 0;
my $storypath = "testdata/story/";
my $boilerplatepath = "boilerplate/";
my $headername = "header.html";
my $footername = "footer.html";
my $storysuffix = ".node";
my $nodepattern = qr/(\d+)/;

#methods
sub validateNodeno{
	my $nodename = shift;
	$nodename =~ $nodepattern;
	return $1;
}
sub grabSnippet{
	my $filepath = $_[0];
	open(my $fh,"<", $filepath) or return "No such content found for $filepath: $!";
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
        close $fh;	
	return $wodgeoftext;
}
sub grabNode{
	my $nodeno = $_[1];
	$nodeno = validateNodeno($nodeno);
	return grabSnippet($storypath.$nodeno.$storysuffix);
}

sub getPage {
	my $nodeno = $_[1];
	$nodeno = validateNodeno($nodeno);
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
