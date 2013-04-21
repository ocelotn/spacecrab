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
	"baseurl" => 'http://hills.ccsf.edu/~lortizde/spacecrab.pl',
	"maxfnamelen" => 32,
	"text400" => "<p>Hmm...That node isn't on our scanners.  Maybe it fell into a black hole?</p>\n"
	};

	sub config {
		return $cfg;
	}

1;
