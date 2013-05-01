use strict;
package spacecrabcfg;
our $VERSION = '1.01';
use base 'Exporter';
our @EXPORT = qw(config);

	my $nameparts = {
	  "storysuffix" => '.node',
	  "imgsuffix" => '.png',
	  "storyprefix" => 'node',
	  "foregroundprefix" => 'FG',
          "midgroundprefix" => 'MG',
	  "backgroundprefix" => 'BG',

            #basic paths
		"storypath" => "testdata/story/",
                "boilerplatepath" => "boilerplate/",
                "imagepath" => "images/",
            #for tests
                "testdata" => "testdata/",
                "baseurl" => 'http://test.space-crab.com/',
            #files 
		"headername" => "header.html",
                "footername" => "footer.html",
                "spacecrab" => "spacecrab.pl",
                "spacecrabmeat" => "spacecrabmeat.pl"
	};
	
	my $defaults = {
	     #node id constraints
                "maxfnamelen" => 32,
                #"nodepattern" => qr/^($storyprefix\w+)($storysuffix)?$/, 
                "nodepattern" => qr/^($nameparts->{"storyprefix"})(\w+)($nameparts->{"storysuffix"})?$/, 
                        #begins with one or more digits,
                        #optionally followed by .node
                        #but nothing else before ending
                #"imageidpattern" => qr/^([FMB]{1}G)(\w+)(\.png)/,
                #"imageidpattern" => qr/^($nameparts->{"foregroundprefix"}|$nameparts->{"$midgroundprefix"}|$nameparts->{"backgroundprefix"})(\w+)($imagesuffix)/,
             #player visible strings
                "text400" => '<div class="story"><p>Hmm...That node isn\'t on our scanners.  Maybe it fell into a black hole?</p></div>',
	     #default files
		"startnode" => "node1",	
                "fgdefault" => "FG1",
                "mgdefault" => "MG1",
                "bgdefault" => "BG1"
	};
	
	my %cfg= (%$nameparts, %$defaults); 

	sub config {
		return \%cfg;
	}
	
1;
