#!/usr/bin/env perl -wT
use strict;
package SpaceCrab;

#config

use lib qw(.);
use spacecrabcfg;
my $cfg = spacecrabcfg::config();



#methods
sub getCleanNodeno{
	my $nodename = shift;
	if (length($nodename) >= $cfg->{"maxfnamelen"}) {
		return ""
	} else { 
		$nodename =~ $cfg->{"nodepattern"};
		return $1;
	}
}

sub grabSnippet{
	#assumes a clean file path
	#returns contents of file as string
	my $filepath = $_[0];
	open(my $fh,"<", $filepath) or return $cfg->{"text400"};
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
    close $fh;	
	return $wodgeoftext;
}

sub grabNode{
	#takes and cleans a node id
	#returns contents of the node or warning if node is invalid
	my $nodeno = (@_ > 1)?$_[1]:$_[0];
	$nodeno = getCleanNodeno($nodeno);
	return ($nodeno ne "" && defined $nodeno)?
		grabSnippet($cfg->{"storypath"}.$nodeno.$cfg->{"storysuffix"}):
		$cfg->{"text400"};
}

sub getPage {
	my $nodeno = $_[1];
	#add boilerplate
	my $page;
	#	add header
	$page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
	#	add story
	$page.=grabNode($nodeno);
	#	add footer
	$page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
	
	#return data
	return $page;
}

1;
