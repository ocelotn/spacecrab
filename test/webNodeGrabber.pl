use strict;
use warnings;
use lib qw(.);
use spacecrabcfg;
use LWP::Simple; 

#my $baseurl = "http://hills.ccsf.edu/~lortizde/spacecrab.pl";
my $cfg = spacecrabcfg::config();

my $node = shift;
die "no node!" unless (defined $node); 


open (my $fh, ">", "$node.html") or die "argh"; 
my $foo = get $cfg->{"baseurl"}; 
print $fh $foo; 
