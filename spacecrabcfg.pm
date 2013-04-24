#!/usr/bin/perl -wT
use strict;
package spacecrabcfg;
our $VERSION = '1.01';
use base 'Exporter';
our @EXPORT = qw(config);

	my $storysuffix = '.node';
	
	my $cfg = {
		#behaviour defaults
		"startnode" => 0,	
		#finding files
		"storypath" => "testdata/story/",
		"boilerplatepath" => "boilerplate/",
		"headername" => "header.html",
		"footername" => "footer.html",
		"storysuffix" => $storysuffix,
		"spacecrab" => "spacecrab.pl",
		"spacecrabmeat" => "spacecrabmeat.pl",
		#node id constraints
		"maxfnamelen" => 32,
		#"nodepattern" => qr/^(\d+)($storysuffix)?$/, 
		#"nodepattern" => qr/^node(\w+)($storysuffix)?$/, 
		"nodepattern" => qr/^(node\w+)($storysuffix)?$/, 
			#begins with one or more digits, 
			#optionally followed by .node 
			#but nothing else before ending
		#player visible strings
		"text400" => '<div class="story"><p>Hmm...That node isn\'t on our scanners.  Maybe it fell into a black hole?</p></div>',
		#for tests
		"testdata" => "testdata/",
		"baseurl" => 'http://test.space-crab.com/'
	};

	sub config {
		return $cfg;
	}
	
1;
