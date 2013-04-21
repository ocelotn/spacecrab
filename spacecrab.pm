#!/usr/bin/env perl -wT
use strict;
package SpaceCrab;

#config

use lib qw(.);
use spacecrabcfg;
my $cfg = spacecrabcfg::config();

#methods
sub validateNodeno{
	my $nodename = shift;
	$nodename =~ $cfg->{"nodepattern"};
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
	return grabSnippet($cfg->{"storypath"}.$nodeno.$cfg->{"storysuffix"});
}

sub getPage {
	my $nodeno = $_[1];
	$nodeno = validateNodeno($nodeno);
	#add boilerplate
	my $page;
	#	add header
	$page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
	#	add story
	$page.=grabSnippet($cfg->{"storypath"}.$nodeno.$cfg->{"storysuffix"});
	#	add footer
	$page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
	
	#return data
	return $page;
}

1;
