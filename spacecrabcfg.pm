#!/usr/local/bin/perl -wT
use strict;
package spacecrabcfg;
our $VERSION = '1.01';
use base 'Exporter';
our @EXPORT = qw(config);

	my $storysuffix = '.node';
	
	my $cfg = {
<<<<<<< HEAD
	"startnode" => 0,
	"storypath" => "testdata/story/",
	"boilerplatepath" => "boilerplate/",
	"headername" => "header.html",
	"footername" => "footer.html",
	"storysuffix" => ".node",
	"nodepattern" => qr/(\d+)/,
	"baseurl" => 'http://test.space-crab.com/',
	"spacecrab" => "spacecrab.pl",
	"spacecrabmeat" => "spacecrabmeat.pl",
	"maxfnamelen" => 32,
	"text400" => "<p>Hmm...That node isn't on our scanners.  Maybe it fell into a black hole?</p>\n",
	"testdata" => "testdata/"
=======
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
		"nodepattern" => qr/^(\d+)($storysuffix)?$/, 
			#begins with one or more digits, 
			#optionally followed by .node 
			#but nothing else before ending
		#player visible strings
		"text400" => "<p>Hmm...That node isn't on our scanners.  Maybe it fell into a black hole?</p>\n",
		#for tests
		"testdata" => "testdata/",
		"baseurl" => 'http://test.space-crab.com/'
>>>>>>> 4aa961cea068c11abf3f2fc0faac20bbfa8be6d9
	};

	sub config {
		return $cfg;
	}
	
1;
