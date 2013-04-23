#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;

use File::Slurp;
use Mojo::DOM;

my $nodepath = "testdata/story";
my $dirmarker = "/";

opendir(DH, $nodepath) or die "couldn't open $nodepath for listing";
my @files = readdir(DH);
closedir(DH);

my $dotfiletext;

sub addEdge{
	my ($dest1, $dest2, $label) = @_;
	$dotfiletext .= $dest1.' -> '.$dest2.' [label = "'.$label.'"];'."\n";
}

sub addNode{
	my ($node, $label) = @_;
	$dotfiletext .= $node.' [label = "'.$label.'"];'."\n";
}


foreach my $file (@files){
	unless ($file =~/^\s*\.+\s*/) {
#	print $file." is the file\n";
	my $nodetext = read_file($nodepath.$dirmarker.$file);
	
	$file =~/(\d*)\.node/;
	my $nodeno = $1;
	
	my $dom = Mojo::DOM->new;
	$dom->parse($nodetext);
	
	my $firstpara = $dom->at('p:first-child');
#	print $firstpara." is the first paragraph.\n";
	
	my $firstline;
	if ($firstpara) {
	   $firstpara =~/(.*?[\.!;])/;
	   $firstline = $1;
	} else {
		$firstline = "Cannot find a first line. Node may be skeletal."
	}
	   
#	print $firstline." is the first line\n";
	addNode($nodeno, $firstline);
	
	$dom->find('a[class="choice"]')->each(sub{
		my $choicetext = $_->text;
#		print $choicetext;
		my @attributes  = $_->attrs;
		foreach my $choice ($_->attrs){
			if ($choice->{"href"}){
				addEdge($nodeno, $choice->{"href"},$choicetext);
			}
			if ($choice->{"dest1"}){
				my $edgelabel = $choicetext;
				my $threshold = $choice->{"threshold"};
				if ($threshold){ 
					$edgelabel.= " : Threshold = ";
					$edgelabel.= 100-$threshold;
				}
				addEdge(
					$nodeno, 
					$choice->{"dest1"},
					$edgelabel
				);
			}
			if ($choice->{"dest2"}){
				my $edgelabel = $choicetext;
				my $threshold = $choice->{"threshold"};
				if ($threshold){
					$edgelabel.= " : Threshold = ".$threshold;
				}
				addEdge( $nodeno, $choice->{"dest2"},$edgelabel);
			}
		}
	});
	
	}
}

print $dotfiletext;
