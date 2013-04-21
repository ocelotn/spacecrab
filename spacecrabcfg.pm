#!/usr/bin/env perl -wT
use strict;

package spacecrabcfg;

	my $cfg = {
	"startnode" => 0,
	"storypath" => "testdata/story/",
	"boilerplatepath" => "boilerplate/",
	"headername" => "header.html",
	"footername" => "footer.html",
	"storysuffix" => ".node",
	"nodepattern" => qr/(\d+)/,
	"baseurl" => 'http://hills.ccsf.edu/~lortizde/spacecrab.pl'
	};

	sub config {
		return $cfg;
	}

1;
