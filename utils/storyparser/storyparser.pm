#!/usr/local/bin/perl
use strict;
use warnings;

use File::Slurp;
use Mojo::DOM;
use lib('../../');
use spacecrabcfg;
package StoryParser;

   #SETUP
   my $cfg = spacecrabcfg::config();
   
sub snarfFile {
   my $file = shift;
      my $nodetext = "";
      $nodetext .= File::Slurp::read_file('../../'.$cfg->{"storypath"}.$file);
      return $nodetext;
}

sub asFiles{
   my $nodehashref = parseOutNodes();
   foreach my $nodeid (keys %$nodehashref){
      open(FH,'>','../../'.$cfg->{"storypath"}.$nodeid.$cfg->{"storysuffix"}) 
      or die "Cannot open file for writing.";
    print FH $nodehashref->{$nodeid};
    close FH;
   }
}

sub error{
	print shift."\n";
}

sub cleantext{
	my $text = shift;
	if($text =~/�/){print "yep\n";} exit;
#	$text =~s/\x{2014}/\&mdash/--/g;
	return $text;
}

sub parseOutNodes{
   my $output = shift;
   my $storyfile = "story.txt";

   #grab the text
   my $nodetext = snarfFile($storyfile); 
   $nodetext = cleantext($nodetext);
   
   my $dom = Mojo::DOM->new->parse($nodetext);

   my %nodehash;

   #foreach story node
   foreach my $nodediv ($dom->find('div[class="story"]')->each)
   {
      #get node id
      my $nodeno = $nodediv->{id};
      if (defined $nodeno){
         if ($nodeno =~$cfg->{"nodepattern"}){
            $nodehash{$nodeno} = $nodediv;
         } else {
            error("Invalid node id for story node "
              .getFirstLine($nodediv));
         } 
      } else { 
         error("No node id for story node ".getFirstLine($nodediv));
      }
   }
   return \%nodehash;
}

sub main {
	return parseOutNodes();
}

1
