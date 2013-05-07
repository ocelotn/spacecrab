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
   my $imagepath = "../../images";
   my $nodefilenamepat = qr/(.*)\.node$/;
   my $dirmarker = "/";
   
   #attribute names
   my $uribase = "http://test.space-crab.com/spacecrab.pl?";
   my $d1 = "data-dest1id";
   my $d2 = "data-dest2id";
   my $deps = "data-ifvisited";
   my $thresh = "threshold";
   my $threshmax = 100;
   
   #graph formatting
    my $hrefcolor = "indigo";
    my $imgcolor = "indigo";
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
#   my $firsttext = shift->at('div[class="story"] *:not(div)');
#   my $firsttext = shift->at('div[class="story"] p|h1|h2|h3|h4|li');
   my $firsttext = shift->at('p|h1|h2|h3|h4|li');
   
   my $firstline;
   if ($firsttext) {
      $firstline = substr $firsttext->text, 0, 50;
   } else {
      $firstline = "Cannot find a first line. Node may be skeletal."
   }
   return $firstline;
}

sub getGraph{   
   #create the graph
   my $graph = GraphViz->new(
      %graphformat, edge=>\%edgeformat, node=>\%nodeformat
   );
   return $graph;
}
sub getDiv{
   my $file = shift;
   my $nodetext = snarfFile($file); 
   my $dom = Mojo::DOM->new->parse($nodetext);

   my  $div = $dom->at("div.story"); #assumes only one story/file
                           #do a find and foreach otherwise
   return $div;   
}
sub addStoryNode{
   my ($graph, $div, $file) = @_;
   #allowing empty nodetext to map possible stub files
   my $nodeno = $div->{'id'};
   my $firstline;
   if ($nodeno){
      $firstline = getFirstLine($div);
   }
   unless ($nodeno) {
      $nodeno = getNodeFromFileName($file);
      if ($nodeno eq '') {die "Can't get nodeno from filename $file.";}
      elsif ($nodeno eq "-1"){print "Node is not parseable from $file."; die;}
      $firstline = "Node file exists but appears empty.";
   }
            
      $graph->add_node(
         $nodeno, 
         label=>$nodeno.":".$firstline, 
         tooltip=>"Node ".$nodeno
      );
      return $nodeno;
}
sub addStraightEdge{
   my ($graph,$source, $dest, $choicetext) = @_;
   $dest =~/(.*)(\.node)?/;
   $graph->add_edge(
      $source => $1, 
      ,head_url => $uribase.$1, tooltip=>$source.",".$1.":".$choicetext
   );
}
sub addForkedEdge{
   my ($graph, $source, $dest1, $dest2, $choicetext) = @_;
      #if it's a forked URL create a subnode for the fork then map from that
            my $forkid = $source.",";
            $forkid.=$dest1.",";
            if ($dest2){$forkid.=$dest2;}
            $graph->add_node(
               $forkid,
               shape=>"point"
               , url=>$uribase.$source, tooltip=>$source.":".$choicetext
            );
            $graph->add_edge(
               $source=>$forkid,
               tail_url=>$uribase.$source,
               tooltip=>$forkid.":".$choicetext);

#            my $threshval = ($choice->{$thresh})?$choice->{$thresh}:"";
#            my $d1chance = ($threshval ne '')? $threshmax-$threshval : 0.50;
#            my $d2chance = $threshval;
#            my $depsval =   ($choice->{$deps})  ?$choice->{$deps}  :"";
            
            if($dest1){
               $graph->add_edge(
                  $forkid => $dest1, 
#                  label => $depsval.$d1chance,
                  color=> $d1color, fontcolor =>$d1color
                  , tail_url=>$uribase.$source
                  , tooltip=>$forkid.":".$choicetext
               )
            } 
            if ($dest2){
               $graph->add_edge(
                  $forkid => $dest2, 
#                  label=> $depsval.$d2chance,
                  color=> $d2color, fontcolor =>$d2color
                  , tail_url=>$uribase.$source
                  , tooltip=>$forkid.":".$choicetext
               )
            }
}

sub addImage{
	my ($graph, $source, $img) = @_;
	my $nodecolor;
	if (-e $imagepath."/".$img){
		$nodecolor = $imgcolor;
	} else {$nodecolor = 'red';}
	$graph->add_node(
		name=> $img,
		tooltip=>"Image ".$img,
		color=>$nodecolor,
		shape=>'circle'
	);
	$graph->add_edge( $source => $img);
	
}

sub main {

   my $graph = getGraph();
   
   #populate the graph
   foreach my $file (getFileSpec($nodepath)){
      my $div = getDiv($file);
      my $nodeno = addStoryNode($graph, $div, $file);
      if ($div) {
         #map edges out of the node
      #      $dom->find('a[class="choice"]')->each(sub{
            $div->find('a')->each(sub{
         
            my $choicetext = $_->text;
            my @attributes  = $_->attrs;
            
            foreach my $choice ($_->attrs){
               if (defined $choice->{$d1} && defined $choice->{$d2}){
                  addForkedEdge(
                     $graph, 
                     $nodeno, 
                     $choice->{$d1},
                     $choice->{$d2},  
                     $choicetext);
               } else {
               #if it's a direct URL, just add a direct edge
               addStraightEdge($graph, $nodeno, $choice->{$d1}, $choicetext);
               }
            }
         });
         if ($div->{'fg'}){
           #addStraightEdge($graph,$nodeno, $div->{'fg'}, "image: ".$div->{'fg'});
           addImage($graph, $nodeno, $div->{'fg'});
         }
#         if ($attribs->{'mg'}){add_edge();}
#         if ($attribs->{'bg'}){add_edge();}
      }
   }
   
   
   print $graph->as_svg;

}
   main();

1
