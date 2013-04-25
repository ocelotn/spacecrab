use strict;
use warnings;
use lib '..';
use spacecrabcfg;

my $cfg = spacecrabcfg::config();

opendir(DH, $cfg->{"storypath"});
my @files = <DH>;

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
		open (my $fh, ">", "$file.raw") or die "argh"; 
		my $foo = get $cfg->{"baseurl"}; 
		print $fh $foo; 
	}
}
