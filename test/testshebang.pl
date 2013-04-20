#!/usr/bin/env perl -wT
print "hello\n";

%result = do "cfg.pl"; 	
        die "Probable syntax error cfg.pl\n" unless ($result);

