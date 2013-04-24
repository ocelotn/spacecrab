use Test::More tests=>5;
use Test::Exception;
use File::Slurp;
use lib ('.');
use spacecrabcfg;
use storyparser;

ok(snarfFile("story.txt"),"getting contents of story file");
dies_ok(sub {snarfFile("bogus.txt")},"dies on bogus story file");
ok(main,"does main complete without dying");
my $nodehashref = parseOutNodes();
ok((keys %$nodehashref) == 14, "node count correct after parsing to hash");
my $nodetext = read_file("testdata/story/node4B1.node");
ok($nodehashref->{"node4B1"} eq $nodetext,
"Known node appears in hash as expected");
