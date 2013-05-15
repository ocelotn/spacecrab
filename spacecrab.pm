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
   my $nodename = pop; #get first parameter as name to clean
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
	
#	 $div->find('a')->map(sub{
#		my $choice = $_; 
#		#$attributes{'href'} = $cfg->{'baseurl'}.
#		$attributes{'href'} = 'spacecrab.pl?';
#		if ($choice->attrs('data-dest2') ne ''){
#		   $attributes{'href'} .= getCleanNodeno($choice->attrs('data-dest2'));
#		} else {
#		   $attributes{'href'} .= getCleanNodeno($choice->attrs('data-dest1'));
#		}
#		   $choice->{'href'} = $attributes{'href'};
#	 });

	 $attributes{'story'} = $div->to_xml;
	 return \%attributes;
}

sub grabNodeData{
	#requires a node id
	#returns a hash of the link infused story and image files for the node
   my $nodeno = getCleanNodeno(pop);
   if (defined $nodeno){ #current format does not allow node id of 0
	   my $contents = grabSnippet(
	      $cfg->{"storypath"}.
	      $nodeno.$cfg->{"storysuffix"}
	   );
	   return parseNode($contents);
	} else {
		  my %defaults = (
			'story'=>$cfg->{'text400'}, 
			'fg'=> $cfg->{'fgdefault'}, 
			'mg'=> $cfg->{'mgdefault'}, 
			'bg'=>$cfg->{'bgdefault'}
			);
		  return \%defaults;
	}
}

sub generateImageLinks {
   #takes mandatory a hash reference of pre-parsed node text
   #returns the default or specified images for the node
   #as a scene div scalar
   my $nodeproperties = shift;
   
   #assemble the image div
   my $links='</div><div class="scene">';
   $links .= '<img src="images/'.$nodeproperties->{"bg"}.'" alt ="background image"/>';
   $links.='<img src="images/'.$nodeproperties->{"mg"}.'" alt="midground image"/>';
   $links.='<img src="images/'.$nodeproperties->{"fg"}.'" alt="foreground image"/>';
#   $links .= '<img src="images/'.$nodeproperties->{"bg"}.$cfg->{"imgsuffix"}.'" alt ="background image"/>';
#   $links.='<img src="images/'.$nodeproperties->{"mg"}.$cfg->{"imgsuffix"}.'" alt="midground image"/>';
#   $links.='<img src="images/'.$nodeproperties->{"fg"}.$cfg->{"imgsuffix"}.'" alt="foreground image"/>';
   $links.='</div>';
   
   #return it
   return $links;
}

sub grabImageLinks{
   #takes a node id
   #returns the default or specified images for the node
   #as a scene div scalar
   my $nodeData = grabNodeData(pop);
   return generateImageLinks($nodeData);
}

sub storyText {
	#takes mandatory hash ref of pre-parsed node text
	#returns story div scalar
	my $nodeproperties = shift;
	return $nodeproperties->{'story'};
}

sub grabNode{
   #takes and cleans a node id
   #returns contents of a valid node 
   #returns the error div if node is invalid
   my $contents = grabNodeData(pop); 
   if (defined $contents->{'story'} && $contents->{'story'} ne ''){
   	return $contents->{'story'};
   } else {return $cfg->{"text400"};}
}

sub getPage {
   my $nodeno = pop;
   #   add boilerplate
   my $page;
   #   add header
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
   #	get content
   my $nodeData = grabNodeData($nodeno);
   $page.=storyText($nodeData);
   $page.="</div>";
   $page.=generateImageLinks($nodeData);
   #   add footer
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
   
   #return data
   return $page;
}

1;
