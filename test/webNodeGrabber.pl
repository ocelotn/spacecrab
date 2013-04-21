use strict;
use warnings;
use LWP::Simple; 

my $baseurl = "http://hills.ccsf.edu/~lortizde/spacecrab.pl";

my $node = shift;
die "no node!" unless (defined $node); 


open (my $fh, ">", "$node.html") or die "argh"; 
my $foo = get $baseurl; 
print $fh $foo; 
