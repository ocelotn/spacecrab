#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;

use File::Slurp;
use Mojo::DOM;

use GraphViz;

my $graph = GraphViz->new(directed => 1, bgcolor=>"linen", node => {shape => 'box'});

my $nodepath = "testdata/story";
my $dirmarker = "/";

opendir(DH, $nodepath) or die "couldn't open $nodepath for listing";
my @files = readdir(DH);
closedir(DH);

foreach my $file (@files){
	unless ($file =~/^\s*\.+\s*/) {
	my $nodetext = read_file($nodepath.$dirmarker.$file);
	
	$file =~/(\d*)\.node/;
	my $nodeno = $1;
	
	my $dom = Mojo::DOM->new;
	$dom->parse($nodetext);
	
	my $firstpara = $dom->at('p:first-child');
	
	my $firstline;
	if ($firstpara) {
	   $firstpara->text =~/(.*?[\.\?\!])/;
	   $firstline = $1;
	} else {
		$firstline = "Cannot find a first line. Node may be skeletal."
	}
	
	$dom->find('a[class="choice"]')->each(sub{
		my $choicetext = $_->text;
		my @attributes  = $_->attrs;
		foreach my $choice ($_->attrs){
			if ($choice->{"href"}){
				$choice->{"href"} =~/(.*)\.node/;
				$graph->add_edge($nodeno => $1, label => $choicetext, color => "indigo", fontcolor => "indigo");
			}
			if ($choice->{"dest1"}){
				my $edgelabel = $choicetext;
				my $threshold = $choice->{"threshold"};
				if ($threshold){ 
					$edgelabel.= " : ";
					$edgelabel.= 100-$threshold;
					$edgelabel.="%";
				}
				$graph->add_edge($nodeno => $choice->{"dest1"}, label => $edgelabel,color => "darkslategray", fontcolor => "darkslategray", width => 1);
			}
			if ($choice->{"dest2"}){
				my $edgelabel = $choicetext;
				my $threshold = $choice->{"threshold"};
				if ($threshold){
					$edgelabel.= " : Threshold = ".$threshold;
				}
				$graph->add_edge($nodeno => $choice->{"dest2"}, label => $edgelabel, color => "tomato", fontcolor => "tomato");
			}
		}
	});
	
	}
}

print $graph->as_svg;
