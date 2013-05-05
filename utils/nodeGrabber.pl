use strict;
use warnings;
use lib qw(.);
use spacecrabcfg;
use LWP::Simple; 

my $cfg = spacecrabcfg::config();

sub getNodePage {
#   pull the web page corresponding to a given node
#	 takes a node name
#	 returns the server response as a string

   my $node = shift;
   if (!defined $node) { die "No node specified!  What should I retrieve?";}
   
   my $url = $cfg->{"baseurl"}.$cfg->{"spacecrab"}."?".$node;
   my $wnode= get($url) or die "cannot retrieve $url!"; 
   
   open (FH, ">", "$node.html") or die "argh"; 
   print FH $wnode;
   close FH;
}

sub getDirList { 
#   get a directly listing - takes a path, 
#   returns an array of file names exluding dot files

   opendir (DH, $cfg->{"storypath"}) or die "cannot read story path";
   #   snarf the directory 
   #   grep out any files beginning with .
   #   strip off the file suffix to leave a list of node ids
   my @dirlist = map {my $node = $_; $node=~s/\.node//; $node;} grep {!/^\./}  readdir(DH);
   close DH;
   return \@dirlist;
} 

#   if webpagegrabber was called with an argument just grab that page
#   otherwise, grab all the nodes from the default web server and service 

my $node = shift;
if (!defined $node){
	print "Getting all known nodes from ".$cfg->{"baseurl"}.$cfg->{"spacecrab"}."\n";
	my $dirlist = getDirList();
	foreach my $rawnode(@$dirlist){
		getNodePage($rawnode);
	}
} else {
	getNodePage($node);
}

0












open(my $fh,"<", $filepath) or return "No such content found for $filepath: $!";
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
        close $fh;	
	return $wodgeoftext;


open (my $fh, ">", "$node.raw") or die "argh"; 
my $foo = get $cfg->{"baseurl"}; 
print $fh $foo; 
close $fh;
