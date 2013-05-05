use strict;
use warnings;
use lib '..';
use spacecrabcfg;
use LWP;

my $cfg = spacecrabcfg::config();

opendir(DH, $cfg->{"storypath"}) or die "could not open dir";
my @files= readdir(DH);

sub grabText {
	my $filepath = shift;
	open(my $fh,"<", $filepath) or return;
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
        close $fh;	
	return $wodgeoftext;
}	
foreach my $file (@files){
	my $nodeText = grabText($cfg->{"storypath"}.$file);
	if (defined $nodeText){
		open (FH, ">", "$file.raw") or die "argh"; 
		#my $foo = get $cfg->{"baseurl"}; 
		#print $fh $foo; 
		print FH $nodeText; 
	}
}
