use strict;
package spacecrabcfg;
our $VERSION = '1.01';
use base 'Exporter';
our @EXPORT = qw(config);

	my $nameparts = {
	   #file parts
                "storysuffix" => '.node',
	        "imgsuffix" => '.png',
	        "storyprefix" => 'node',
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
                "spacecrabmeat" => "spacecrabmeat.pl",
	    #default files
	       "startnode" => "node1",	
               "fgdefault" => "FG1",
               "mgdefault" => "MG1",
               "bgdefault" => "BG1"
	};
	
	my $patternsnstrings= {
	     #id constraints
                "maxfnamelen" => 32,
                #"nodepattern" => qr/^($storyprefix\w+)($storysuffix)?$/, 
                #"nodepattern" => qr/^((nameparts->{"storyprefix"})?(\w+))($nameparts->{"storysuffix"})?$/, 
                "nodepattern" => qr/^($nameparts->{"storyprefix"}\w+)($nameparts->{"storysuffix"})?$/, 
                        #begins with one or more digits,
                        #optionally followed by .node
                        #but nothing else before ending
                 #"imgpattern" => qr/^([FMB]{1}G\w+)($nameparts->{"imgsuffix"})?$/,
                 "imgpattern" => qr/^([FMB]{1}G\w+)($nameparts->{"imgsuffix"})?$/,
			#begins with one F,M or B followed by a G
			#followed by one or more word characters
			#optionally followed by an image file suffix
			#but nothing else before the end
             #player visible strings
		"text400" => '<div class="story"><p>Hmm...That node isn\'t on our scanners.  Maybe it fell into a black hole?</p></div>',
	};
	
	my %cfg= (%$nameparts, %$patternsnstrings); 

	sub config {
		return \%cfg;
	}
	
1;
