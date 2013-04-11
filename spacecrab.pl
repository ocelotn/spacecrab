#! /usr/bin/perl

#config
my $startnode = 0;
my $storypath = "testdata/story/";

#methods
sub grabSnippet{
	my $filepath = $_[0];
	open(my $fh,"<", $filepath) or return "No such content found for $filepath: $!";
	my $wodgeoftext;
	while(<$fh>){$wodgeoftext.=$_;}
	return $wodgeoftext;
}

#init
my $nodeno = ($argv[0])?$argv[0]:$startnode;

#add boilerplate
my $page;
#	add header
#	add story
$page.=grabSnippet($storypath.$nodeno.".node");
#	add footer

#return data
print $page;
#return $page;
