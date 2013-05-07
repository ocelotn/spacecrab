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
	
	 $div->find('a')->map(sub{
		my $choice = $_; 
		#$attributes{'href'} = $cfg->{'baseurl'}.
		$attributes{'href'} = 'spacecrab.pl?';
		if ($choice->attrs('data-dest2id') ne ''){
		   $attributes{'href'} .= getCleanNodeno($choice->attrs('data-dest2id'));
		} else {
		   $attributes{'href'} .= getCleanNodeno($choice->attrs('data-dest1id'));
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
   my $nodeproperties = pop;
   
   #If this the text has already been parsed, just use that
   #otherwise get it and parse it first
   if (ref($nodeproperties) ne 'HASH' || !defined ref($nodeproperties)){
   	$nodeproperties = grabNodeData($nodeproperties); 
   }
   
   #assemble the image div
   my $links='</div><div class="scene">';
   $links .= '<img src="images/'.$nodeproperties->{"bg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='<img src="images/'.$nodeproperties->{"mg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='<img src="images/'.$nodeproperties->{"fg"}.$cfg->{"imgsuffix"}.'"/>';
   $links.='</div>';
   
   #return it
   return $links;
}

sub grabNodeData{
	#requires a node id
	#returns a hash of the link infused story and image files for the node
   my $nodeno = getCleanNodeno(pop);
   if ($nodeno){ #current format does not allow node id of 0
	   my $contents = grabSnippet(
	      $cfg->{"storypath"}.
	      $nodeno.$cfg->{"storysuffix"}
	   );
	   return parseNode($contents);
	} else {
		return {
			'story'=>$cfg->{'text400'}, 
			'fg'=> $cfg->{'fgdefault'}, 
			'mg'=> $cfg->{'mgdefault'}, 
			'bg'=>$cfg->{'bgdefault'}
		};
	}
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
   my $nodeno = getCleanNodeno(pop);
   #   add boilerplate
   my $page;
   #   add header
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"headername"});
   #	get content
   $page.=grabNode($nodeno);
   $page.=grabImageLinks($nodeno);
   #   add footer
   $page.=grabSnippet($cfg->{"boilerplatepath"}.$cfg->{"footername"});
   
   #return data
   return $page;
}

1;
