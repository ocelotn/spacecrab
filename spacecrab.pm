use strict;
use File::Slurp;
use Mojo::DOM;
use lib('.');
use spacecrabcfg;

package SpaceCrab;

#config

use lib qw(.);
use spacecrabcfg;
my $cfg = spacecrabcfg::config();

#methods
sub getCleanNodeno{
   #takes a node id string as input
   #sanity checks it for length and matching a defined node id pattern
   #returns the node id scalar for node ids that appear valid
   #returns undefined for node ids that appear bogus
   my $nodename = shift; #get first parameter as name to clean
   if (length($nodename) >= $cfg->{"maxfnamelen"}) {
      return;
   } else { 
      $nodename =~ $cfg->{"nodepattern"};
      return $1; 
   }
}

sub grabSnippet{
   #assumes a clean file path
   #returns contents of file as string
   my $filepath = $_[0];
   open(my $fh,"<", $filepath) or return $cfg->{"text400"};
   my $wodgeoftext;
   while(<$fh>){$wodgeoftext.=$_;}
    close $fh;   
   return $wodgeoftext;
}

sub parseNode{
 my $dom = Mojo::DOM->new(shift);
 my $div = $dom->find('div[class"story"]');
 my %attributes;
 $images{"fg"} = $dom->pluck('fg'):$cfg->{"fgdefault"};
 $images{"mg"} = $dom->pluck('mg'):$cfg->{"mgdefault"};
 $images{"bg"} = $dom->pluck('bg'):$cfg->{"bgdefault"};
 return \%attributes;
}

sub grabNode{
   #takes and cleans a node id
   #returns contents of a valid node 
   #returns the error div if node is invalid
   my $nodeno = pop;
   $nodeno = getCleanNodeno($nodeno);
   return (defined $nodeno)?
      grabSnippet($cfg->{"storypath"}.$nodeno.$cfg->{"storysuffix"}):
      $cfg->{"text400"};
}

sub getPage {
   my $nodeno = $_[1];
   #add boilerplate
   my $page;
   #   add header
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
   #   get content
   my $nodetext = grabNode($nodeno);
        my $images = parseNode($nodetext);   
   #   add story
   $page.=grabNode($nodeno);
   #   add images
   $page.='</div><div class="scene"><img src="images/"';
   $page.=$images->{"bg"};
   $page.='"/><img src="images/"'.$images->{"mg"};
   $page.='"/><img src="images/".$images->{"fg"}.'"/>';
   #   add footer
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
   
   #return data
   return $page;
}

1;
