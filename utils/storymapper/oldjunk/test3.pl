#!/usr/bin/perl
use strict;
use warnings;

use Data::Dumper;

use File::Slurp;
use Mojo::DOM;

use GraphViz;

#path variables
my $nodepath = "testdata/story";
my $dirmarker = "/";

#attribute names
my $uribase = "http://hills.ccsf.edu/~lortizde/spacecrab.pl?";
my $d1 = "data-dest1";
my $d2 = "data-dest2";
my $deps = "data-ifvisited";
my $thresh = "threshold";
my $threshmax = 100;

#graph formatting
my $hrefcolor = "indigo";
my $d1color = "darkslategray";
my $d2color = "tomato4";
my $graph = GraphViz->new(
	directed => 1, 
	bgcolor=>"linen", 
	node => {shape => 'box', fontsize=>10.0, color=>"gray"}, 
	edge=>{fontsize=>8.0,color=>$hrefcolor, fontcolor=>$hrefcolor}
);


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
	$graph->add_node($nodeno, label=>$nodeno.":".$firstline);
	
	#map edges out of the node
	$dom->find('a[class="choice"]')->each(sub{
	
		my $choicetext = $_->text;
		my @attributes  = $_->attrs;
		
		foreach my $choice ($_->attrs){
			#if it's a direct URL, just add a direct edge
			if ($choice->{"href"} ne ""){
				$choice->{"href"} =~/(.*)\.node/;
				$graph->add_edge(
					$nodeno => $1, 
					color => $hrefcolor, fontcolor => $hrefcolor
					,head_url => $uribase.$1, tooltip=>$nodeno.",".$1.":".$choicetext
				);
			} else {
			#otherwise create a subnode to represent the fork
			#then map edges from that
				my $forkid = $nodeno.",";
				$forkid.=$choice->{$d1}.",";
				$forkid.=$choice->{$d2};
				$graph->add_node(
					$forkid,
					shape=>"point"
					, url=>$uribase.$nodeno, tooltip=>$nodeno.":".$choicetext
				);
				#my $forkid = $graph->add_node(shape=>"point");
				

				$graph->add_edge(
					$nodeno=>$forkid, 
					tail_url=>$uribase.$nodeno,
					tooltip=>$forkid.":".$choicetext);

				my $threshval = ($choice->{$thresh})?$choice->{$thresh}:"";
				my $d1chance = $threshmax-$threshval;
				my $d2chance = $threshval;
				my $depsval =   ($choice->{$deps})  ?$choice->{$deps}  :"";
				
				
				if($choice->{$d1}){
					$graph->add_edge(
						$forkid => $choice->{$d1}, 
						label => $depsval.$d1chance,
						color=> $d1color, fontcolor =>$d1color
						, tail_url=>$uribase.$nodeno
						, tooltip=>$forkid.":".$choicetext
					)
				} 
				if ($choice->{$d2}){
					$graph->add_edge(
						$forkid => $choice->{$d2}, 
						label=> $depsval.$d2chance,
						color=> $d2color, fontcolor =>$d2color
						, tail_url=>$uribase.$nodeno
						, tooltip=>$forkid.":".$choicetext
					)
				}
			}
		}
	});
	
	}
}

print $graph->as_svg;
