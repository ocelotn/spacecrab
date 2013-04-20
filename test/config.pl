#!/usr/bin/env perl -wT
use strict;

my %cfg => {
	startnode => 0,
	storypath => "testdata/story/",
	boilerplatepath => "boilerplate/",
	headername => "header.html",
	footername => "footer.html",
	storysuffix => ".node",
	nodepattern => qr/(\d+)/
}

return \%cfg;

