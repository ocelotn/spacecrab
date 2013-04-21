use strict;
use warnings;
use lib qw(.);
use spacecrabcfg;

my $cfg = spacecrabcfg::config();

my $node = shift;
die "no node!" unless (defined $node); 

open(my $fh,"<", $filepath) or return "No such content found for $filepath: $!";
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
        close $fh;	
	return $wodgeoftext;


open (my $fh, ">", "$node.raw") or die "argh"; 
my $foo = get $cfg->{"baseurl"}; 
print $fh $foo; 
