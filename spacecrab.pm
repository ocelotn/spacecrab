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
	#takes a wodge of xml/html
	#returns a hash of image zone attributes
	#and the text itself with first pass choice paths set
 
	 my %attributes;
	 
	 my $dom = Mojo::DOM->new(shift);
	 my $div = $dom->at('div[class="story"]');
	 
	 my @zones = ('fg','mg','bg');
	 foreach my $zone (@zones) {
		#   get any image attributes for the div
		my $vals = $div->attrs($zone);
		#   supply defaults & validate filename
		$attributes{$zone} = ( 
			$vals=~ $cfg->{"imgpattern"}
		)? $vals:$cfg->{$zone."default"};
	 }
	
	 $div->find('a')->map(sub{
		my $choice = $_; 
		#$attributes{'href'} = $cfg->{'baseurl'}.
		$attributes{'href'} = 'spacecrab.pl?';
		if ($choice->attrs('data-dest2')){
		   $attributes{'href'} .= $choice->attrs('data-dest2');
		} else {
		   $attributes{'href'} .= $choice->attrs('data-dest1');
		}
		   $choice->{'href'} = $attributes{'href'};
	 });
	 $attributes{'story'} = $div->to_xml;
	 return \%attributes;
}

sub grabImageLinks{
   #takes either a hash reference of pre-parsed node text
   #or a scalar of node text
   #returns the default or specified images for the node
   #as a scene div scalar
   
   #make sure we have the attributes from parsed node text
   my $images = shift;
   if (ref($images) ne 'HASH'){
   	$images = parseNode(grabNode($images)); 
   }

   my $links='</div><div class="scene">';
   $links = '<img src="images/'.$images->{"bg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='<img src="images/'.$images->{"mg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='<img src="images/'.$images->{"fg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='</div>';
   return $links;
}

sub grabNode{
   #takes and cleans a node id
   #returns contents of a valid node 
   #returns the error div if node is invalid
   my $nodeno = shift;
   $nodeno = getCleanNodeno($nodeno);
   return (defined $nodeno)?
      grabSnippet($cfg->{"storypath"}.$nodeno.$cfg->{"storysuffix"}):
      $cfg->{"text400"};
}

sub getPage {
   my $nodeno = $_[1];
   #   add boilerplate
   my $page;
   #   add header
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
   #get content
   my $nodestuff = parseNode(grabNode($nodeno));
   $page.=$nodestuff->{'story'};
   $page.=grabImageLinks($nodestuff);
   #   add footer
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
   
   #return data
   return $page;
}

1;
