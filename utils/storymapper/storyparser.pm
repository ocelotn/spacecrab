#!/usr/local/bin/perl
use strict;
use warnings;

use File::Slurp;
use Mojo::DOM;

	#SETUP
	#path variables
	my $nodepath = "../testdata/story";
	my $nodefilenamepat = qr/(.*)\.node$/;
	my $dirmarker = "/";
	my $nodesuffic = ".node";
	
sub snarfFile {
	my $file = shift;
		my $nodetext = "";
		$nodetext .= File::Slurp::read_file($nodepath.$dirmarker.$file);
		return $nodetext;
}

sub getFirstLine{
#	my $firsttext = shift->at('div[class="story"] *:not(div)');
	my $firsttext = shift->at('div[class="story"] p|h1|h2|h3|h4|li');
	
	my $firstline;
	if ($firsttext) {
		$firstline = substr $firsttext->text, 0, 50;
	} else {
		$firstline = "Cannot find a first line. Node may be skeletal."
	}
	return $firstline;
}

sub main {	
	#grab the text
	my $nodetext = snarfFile($file); 
	my $dom = Mojo::DOM->new->parse($nodetext);

	#foreach story node
	foreach my $nodediv ($dom->children('div[class="story"]'))
	{
		#get node id
		my $nodeno = $nodediv->{id};
		if (defined $nodeno){
			if ($nodeno =~/\d+/){
				open(FH,'>',$nodepath.$dirmarker.$nodeno.$nodesuffix) or die "Cannot open file for writing.";
				print FH, $nodediv;
				close FH;
			} else { error("Invalid node id for story node ".getFirstLine($nodediv)."\n");
		} else { error("No node id for story node ".getFirstLine($nodediv)."\n");}
	}


}
	main();

1
