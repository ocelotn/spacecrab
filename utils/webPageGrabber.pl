use strict;
use warnings;
use lib qw(.);
use spacecrabcfg;
use LWP::Simple; 

my $cfg = spacecrabcfg::config();

sub getNodePage {
my $node = shift;
if (!defined $node) { die "No node specified!  What should I retrieve?";}

open (my $fh, ">", "$node.html") or die "argh"; 
my $url = $cfg->{"baseurl"}.$cfg->{"spacecrab"}."?".$node;
my $wnode= get($url) or die "cannot retrieve $url!"; 
print $fh $wnode;
}

sub getDirList { 
	opendir (DH, $cfg->{"storypath"}) or die "cannot read story path";
	my @dirlist = grep {!/^\./} readdir(DH); 
	my @dirlist2 = map {my $node = $_; $node=~s/\.node//; $node;} @dirlist;
	close DH;
	return \@dirlist2;
} 

my $node = shift;
if (!defined $node){
	my $dirlist = getDirList();
	foreach my $rawnode(@$dirlist){
		getNodePage($rawnode);
	}
} else {
	getNodePage($node);
}
