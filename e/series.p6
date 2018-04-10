#!/usr/bin/env perl6

# Estimate the constant e by summing terms from the series
#  F(n) = 1 / n!, n=0..Infinity
#

my $maxterms = 1000;
my $e = FatRat.new(1, 1); # accumulate e
my $next = FatRat.new(1, 1); # next term - don't reevaluate factorials
my $j;
for 1..$maxterms - 1 -> $n {
        $next /= $n;
        $e += $next; 
        $j = $n + 1;
        say "Terms $j; Estimate $e";
}
