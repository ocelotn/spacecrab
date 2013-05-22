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

#NOTE - graphviz requires node names that use only \w and ' ' characters.  Dash, dot, colon or other punctuation causes it to conflate nodes!

   #SETUP
   #path variables
   my $nodepath = "../../testdata/story";
   my $imagepath = "../../images";
   my $nodefilenamepat = qr/(\w*)(\.node)?$/;
   my $dirmarker = "/";
   
   #attribute names
   my $uribase = "http://test.space-crab.com/spacecrab.pl?";
   my $d1 = "data-dest1";
   my $d2 = "data-dest2";
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
       style => "filled",
       color => "gray",
       fillcolor => "linen"
    );
   my %edgeformat = (
      fontsize => 8.0,
      color => $hrefcolor,
      fontcolor => $hrefcolor,
    );
    my %graphformat = (
       directed => "TRUE",
       bgcolor => "linen",
       label => "Spacecrab Story Map"
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
   return $1;
#   return (defined $1)?$1:-1;
}
sub getFirstLine{
#   my $firsttext = shift->at('div[class="story"] *:not(div)');
#   my $firsttext = shift->at('div[class="story"] p|h1|h2|h3|h4|li');
   my $firstline = shift->at('p|h1|h2|h3|h4|li');
   if ($firstline) {
      $firstline = substr $firstline->text, 0, 50;
   } else {
      $firstline = "Cannot find a first line. Node may be skeletal."
   }
   return $firstline;
}
sub checkforEnd{
	my $div = shift;
	#if the div text ends in THE END
	#possibly followed by a dot, whitespace or 
	#a closing tag, return true else false
#	return ($div->text=~/THE END\.?\s*(<\/\s*\w+\s*>)?\s*$/)?1:0;
	return ($div->all_text=~/THE END\.?\s*(<\/\s*\w+\s*>)?\s*$/)?1:0;
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

   my $nodeno = $div->{'id'};
   my $firstline;
   
   #allowing empty nodetext to map possible stub files
   unless ($nodeno) {
      $nodeno = getNodeFromFileName($file);
      $firstline = "Node file exists but appears empty.";
      if ($nodeno eq '') {die "Can't get nodeno from filename $file.";}
      elsif ($nodeno eq "-1"){print "Node is not parseable from $file."; die;}
      warn "no node name! for $file - trying $nodeno";   
   }

   #setting up parameters
	if ($nodeno=~$nodefilenamepat){$nodeno = $1;} 
	   else {warn "Non standard node id $nodeno";}
	$firstline = getFirstLine($div);
 	my $tooltip = $div->children()->first->text;
# 	#my $tooltip = $div->children()->first->text;
# 	my $tooltip = '';
# 	if ($div->children()->size > 0){$tooltip = $div->children()->first->text;}
# 	elsif ($div->text){$tooltip = $div->text;}
# 	$tooltip =~s/[\'\"]//g;

    $graph->add_node(
         $nodeno,
         label=>$nodeno.":\n".$firstline, 
         tooltip=>"Node ".$nodeno." ".$tooltip
    ) or die "cannot add node $nodeno for $file\n";

    return $nodeno;
}
sub addImage{
	my ($graph, $source, $img) = @_;
	my $nodecolor=(-e $imagepath."/".$img)?
      $imgcolor:'red';
	$img =~s/(\w+).*/$1/;
	$graph->add_node(
		name=> $img,
		tooltip=>"Image ".$img,
		color=>$nodecolor,
		shape=>'oval',
		splines=>'true'
	) or die "no node added for $img";
	$graph->add_edge($source => $img);
}
sub addChoices{
  my ($div, $graph, $source) = @_;
  my $links = $div->find('a');
  if (defined $links && $links->size > 0){
	 $links->each(sub{
	   my $choice = $_;
	   my $choicetext = $choice->text;
       my $forkid;
       
       #if it is a forked choice with two destinations
       #add a fork point and edges from that to each dest
	   if (defined $choice->{$d2} && defined $choice->{$d1}){
		  $forkid = $source.' '.$choice->{$d1}.' '.$choice->{$d2};
		  $graph->add_node(
			 $forkid
			 , shape=>"point"
			 , url=>$uribase.$source
			 , tooltip=>$source.":".$choicetext
		  ) or die "could not add forkpoint $forkid";
  
		  $graph->add_edge(
			 $source=>$forkid,
			 tail_url=>$uribase.$source,
			 tooltip=>$forkid.":".$choicetext
		  ) or die "could not add edge from $source to $forkid";
			  
		  $graph->add_edge(
			 $forkid => $choice->{$d2} 
   #         , label=> $depsval.$d2chance
			 , color=> $d2color 
			 , fontcolor =>$d2color
			 , tail_url=>$uribase.$source
			 , tooltip=>$forkid.":".$choicetext
		  ) or die "could not add edge from $source to ".$choice->{$d2};
	   }

	   if (defined $forkid){$source = $forkid;}
	   #either way, add an edge to dest1
	    if (!defined $choice->{$d1} || !defined $source){
	       die "something is wrong - either no source or dest1";
	    }
		$graph->add_edge(
		   $source => $choice->{$d1}
	 #     , label => $depsval.$d1chance
		   , color=> $d1color
		   , fontcolor =>$d1color
		   , tail_url=>$uribase.$source
		   , tooltip=>$source.":".$choicetext
		) or die "could not add edge from $source to ".$choice->{$d1};
	 });
	 return 1;
  }
  return 0;
}

sub main {

   my $graph = getGraph();
   
   #populate the graph
   my @filestoprocess = (@ARGV >= 1)?@ARGV:getFileSpec($nodepath);
   
   foreach my $file (@filestoprocess){   
      #get the node contents
      my $div = getDiv($file);
      unless ($div) {$div = Mojo::DOM->new('<div><p>EMPTY FILE!</p></div>')}
      #add the node
      my $nodeno = addStoryNode($graph, $div, $file);
      #if the node is not empty
      if ($div) {
      #	map any edges out of the node
		 unless(addChoices($div, $graph, $nodeno)){ 
		 #if there are no story links going out
			if (checkforEnd($div)){
					#intentional ending
					$graph->add_node($nodeno, %nodeformat,  fillcolor=>'lightgray');
			} else {
					#this node may be an unintentional dead end
					$graph->add_node($nodeno, %nodeformat, color=>'red');
			}
		 }
         #check for non-default images
		 foreach my $attr (qw(fg mg bg)){		 
#		   if ($div->{$attr}){addImage($graph, $nodeno, $div->{$attr});}
		 }		   
      } #node processed
  } #all files processed
  print $graph->as_svg;
}

main();
1
