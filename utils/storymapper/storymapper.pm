#!/usr/bin/perl
use strict;
use warnings;

use File::Slurp;
use Mojo::DOM;
use GraphViz;

#package StoryMapper;

#Author Lara O. 15 
#Last modified April 2012

#TODO:
#-decide what to export
#-move config out of code and share with test
#-bring sm and tests into line with final syntax
#-clean up "main" into useful methods
#-consistent error handling - may need better sense of
#what story generation process is - is what are valid nodes
#-add auto-detection and output of problem or missing nodes.
#-prettify


	#SETUP
	#path variables
	my $nodepath = "../../testdata/story";
	my $nodefilenamepat = qr/(.*)\.node?$/;
	my $dirmarker = "/";
	
sub getFileSpec {
	opendir(DH, shift) or die "couldn't open $nodepath for listing";
	my @files = grep {!/^\./} readdir(DH);
	closedir(DH);

	@files = grep {/node\w*\.node/} @files;

	return @files;	
	#ret. all files whose names do not begin with a dot
}

sub snarfFile {
	my $file = shift;
		my $nodetext = "";
		$nodetext .= File::Slurp::read_file($nodepath.$dirmarker.$file);
		return $nodetext;
}

sub getNodeFromFileName {
	my $file = shift;
	$file =~ $nodefilenamepat;
	return (defined $1)?$1:-1;
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
	#SETUP
	#attribute names
	my $uribase = "http://test.space-crab.com/spacecrab.pl?";
	my $d1 = "data-dest1id";
	my $d2 = "data-dest2id";
	my $deps = "data-ifvisited";
	my $thresh = "threshold";
	my $threshmax = 100;
	
	#graph formatting
 	my $hrefcolor = "indigo";
 	my $d1color = "darkslategray";
	my $d2color = "tomato4";
 	my %nodeformat = ( 
 		shape=> "box", 
 		fontsize=> 10.0, 
 		color => "gray"
 	);
	my %edgeformat = (
		fontsize => 8.0,
		color => $hrefcolor,
		fontcolor => $hrefcolor
 	);
 	my %graphformat = (
 		directed => "TRUE",
 		bgcolor => "linen"
 	);
	
	#create the graph
	my $graph = GraphViz->new(
		%graphformat, edge=>\%edgeformat, node=>\%nodeformat
	);

	#populate the graph
	foreach my $file (getFileSpec($nodepath)){
	
		#allowing empty nodetext to map possible stub files
		my $nodetext = snarfFile($file); 
		
		my $dom = Mojo::DOM->new->parse($nodetext);

		my $nodeno = getNodeFromFileName($file);
		if ($nodeno eq '') {die "Can't get nodeno from filename $file.";}
#		elsif ($nodeno eq "-1"){print "Node is not parseable from $file."; die;}

		my $firstline = getFirstLine($dom);
		$graph->add_node($nodeno, label=>$nodeno.":".$firstline, tooltip=>"Node ".$nodeno);

	#map edges out of the node
#		$dom->find('a[class="choice"]')->each(sub{
		$dom->find('a')->each(sub{
	
		my $choicetext = $_->text;
		my @attributes  = $_->attrs;
		
		foreach my $choice ($_->attrs){
			#if it's a direct URL, just add a direct edge
			if (defined $choice->{"href"} and $choice->{"href"} ne ""){
				$choice->{"href"} =~/(.*)\.node/;
				$graph->add_edge(
					$nodeno => $1, 
					,head_url => $uribase.$1, tooltip=>$nodeno.",".$1.":".$choicetext
				);
			} else {
			#otherwise create a subnode to represent the fork
			#then map edges from that
				my $forkid = $nodeno.",";
				$forkid.=$choice->{$d1}.",";
				if ($choice->{$d2}){$forkid.=$choice->{$d2};}
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
				my $d1chance = ($threshval ne '')? $threshmax-$threshval : 0.50;
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
	print $graph->as_svg;

}
	main();

1
