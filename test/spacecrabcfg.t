#!/usr/bin/env perl
use strict;
use warnings;
use Test::Simple tests=>4;
use spacecrabcfg;

my $cfg = spacecrabcfg::config();

my $fgpath = $cfg->{"fgdefault"};
ok(defined $cfg && ref($cfg) eq "HASH", "config returns a hash ref");
ok('FG1.png' eq $cfg->{"fgdefault"}, "foreground default is set");
ok('MG1.png' eq $cfg->{"mgdefault"}, "midground default is set");
ok('BG1.png' eq $cfg->{"bgdefault"}, "background default is set");

1

