use Test::Simple tests=>1;
use lib ('.');
use spacecrabcfg;
use storyparser;

ok(snarfFile("story.txt"),"getting contents of story file");
ok(main,"does main complete without dying");
